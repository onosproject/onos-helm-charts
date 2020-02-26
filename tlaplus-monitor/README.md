# TLA+ Conformance Monitor

Provides a Helm chart that enables near-real time conformance monitoring with [TLA+].

The conformance monitor uses the TLA+ specification language and the TLC model checker to evaluate
system trace streams to detect violations of system safety properties. This chart can configure and
run arbitrary TLA+ conformance monitoring specs and their dependencies.

### Prerequisites

The conformance monitor currently requires Kafka to stream traces to TLC.

To deploy Kafka using Helm, first add the incubator repository to your Helm configuration:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
```

Define a `values.yaml` file for your Kafka cluster, configuring the topics to be used by the conformance monitor
to consume traces and produce alerts:

```yaml
replicas: 1
zookeeper:
  replicaCount: 1
topics:
  - name: traces
    partitions: 3
    replicationFactor: 1
  - name: alerts
    partitions: 1
    replicationFactor: 1
```

Then, install the `incubator/kafka` chart with the desired configuration overrides:

```bash
$ helm install kafka incubator/kafka --values values.yaml
```

The successful completion of the `kafka-config` pod indicates the Kafka brokers have completed startup and
configured topics have been created.

### Installation

Once the Kafka cluster has been configured, this chart can be deployed to perform near real-time conformance
monitoring on Kafka streams. The monitor uses [TLA+] specifications to evaluate traces received from Kafka,
and invariants specified in the chart configuration can detect safety violations in the trace stream.

Several artifacts are required to by the chart:
* `model` - the name of the module to evaluate
* `modules` - an array of TLA+ module files to mount to the monitor pod
* `spec` - the specification to evaluate
* `init` - the state initialization predicate (required if `spec` is not configured)
* `next` - the next state relation (required if `spec` is not configured)

Additional options can be used to specify invariants and other constraints on the model checker:
* `invariants` - an array of invariants to check for each trace
* `constants` - a mapping of constant values to assign to the model
* `constraints` - an array of state constraints
* `properties` - an array of model properties

```bash
$ helm install my-monitor --set modules={Cache.tla,CacheHistory.tla} --set model=Cache.tla --set config.spec=Spec --set config.invariants={TypeOK}
```

## Specifications

The role of the conformance monitor is to track the system state over time and detect violations
of safety guarantees by analyzing the system state. To do so, [TLA+] specifications are used to
provide a formal model for state transitions and specify the invariants to which the system must
conform.

TLA+ specifications consist of one or more modules defined in `.tla` files. A module defines a set
of formulas for evaluating the state of the system. The specification provides a formula describing
the initial system state and its transitions:

```
---------------------------- MODULE MonotonicTrace --------------------------

EXTENDS Naturals, Sequences

\* A list of variables in the spec
vars == <<...>>

\* The init predicate describing the initial state of the system
Init == ...

\* The next state relation describing possible state transitions
Next == ...

\* The system specification describes the initial system state and next state relations
Spec == Init /\ [][Next]_<<vars>>

=============================================================================
```

Typically, the TLA+ model checker, TLC, computes and evaluates every state that can be reached
by the spec according to its initial state and next state relation. Conformance monitoring specs
operate on an infinite stream of traces, using the `NextTrace` operator to consume and check
traces in near-real time:

```
INSTANCE Traces

\* The previous trace version
VARIABLE prevVersion

\* The current trace version
VARIABLE nextVersion

\* A list of variables in the spec
vars == <<prevVersion, nextVersion>>

\* Read a trace record from the stream and update the previous and next versions
Read ==
    LET record == NextTrace
    IN
       /\ PrintT(record)
       /\ prevVersion' = nextVersion
       /\ nextVersion' = record.version

\* The init predicate describing the initial state of the system
Init ==
    /\ prevVersion = 0
    /\ nextVersion = 0

\* The next state relation describing possible state transitions
Next ==
    \/ Read
    \/ UNCHANGED <<vars>>
```

The final component of a conformance spec is the invariant(s). Invariants are predicates
that describe the properties of a well behaved (conforming) system. After each trace is
consumed and processed from the traces stream, TLC will evaluate invariants to determine
whether the system's state conforms to its safety properties:

```
\* An invariant verifying that the trace version is monotonically increasing
TypeOK == nextVersion # 0 => nextVersion < prevVersion
```

In the event the invariant is violated by the system traces, the `PublishAlert` operator
can be used to publish an alert.

```
INSTANCE Alerts

\* An invariant verifying that the trace version is monotonically increasing
TypeOK ==
    \/ nextVersion # 0 => nextVersion < prevVersion
    \/ PublishAlert([msg         |-> "Invariant violated",
                     prevVersion |-> prevVersion,
                     nextVersion |-> nextVersion])
```

With the initial state predicate, the next state relation, and the type invariants,
a complete conformance monitoring spec can be compiled:

```
---------------------------- MODULE MonotonicTrace --------------------------

EXTENDS Naturals, Sequences

INSTANCE Traces

INSTANCE Alerts

\* The previous trace version
VARIABLE prevVersion

\* The current trace version
VARIABLE nextVersion

\* A list of variables in the spec
vars == <<prevVersion, nextVersion>>

\* An invariant verifying that the trace version is monotonically increasing
TypeOK ==
    \/ nextVersion # 0 => nextVersion < prevVersion
    \/ PublishAlert([msg         |-> "Invariant violated",
                     prevVersion |-> prevVersion,
                     nextVersion |-> nextVersion])

\* Read a trace record from the traces stream and update the previous and next versions
Read ==
    LET record == NextTrace
    IN
       /\ PrintT(record)
       /\ prevVersion' = nextVersion
       /\ nextVersion' = record.version

\* The init predicate describing the initial state of the system
Init ==
    /\ prevVersion = 0
    /\ nextVersion = 0

\* The next state relation describing possible state transitions
Next ==
    \/ Read
    \/ UNCHANGED <<vars>>

\* The system specification describes the initial system state and next state relations
Spec == Init /\ [][Next]_<<vars>>

=============================================================================
```

To deploy the specification for conformance monitoring, the chart must be configured to
identify the specification `Spec` and its invariant `TypeOK`:

```bash
$ helm install my-monitor --set modules={MonotonicTrace.tla} --set model=MonotonicTrace.tla --set config.spec=Spec --set config.invariants={TypeOK}
```

The model will be initialized with the `prevVersion` and `nextVersion` set to `0`.
As traces are pushed onto the traces stream, the model checker will `Read` the trace
records, update the model state, and evaluate the invariant `TypeOK`.

[TLA+]: https://lamport.azurewebsites.net/tla/tla.html
[Kafka]: https://kafka.apache.org/
