Alerting
========

Alerts provide a mechanism to manage and monitor your HealthShare productions.
Every component supports alerting - the functionality is baked into the
base service/process/operations classes.

In order to configure your HealthShare productions for alerting you need to:

1. Figure out what you want to monitor.
2. Decide who and how you wish to broadcast an alert.
3. Add a component to handle alerts.
4. Configure the components you wish to monitor.
5. Congifure your alert handler.

The first 2 steps are likely the most difficult since they will vary with your
particular solutions, your customers, or your service level agreements. For demonstration
purposes, we'll assume the following scenario and then walk through all the steps.

### Sample Production Scenario
You application uses HealthShare to process an inbound HL7 feed. This processing includes 
conversion of the HL7 into CDA documents which then get sent off to a downstream
repository. You also send off statistics of the incoming HL7 to a custom application
which keeps track of basic patient demographics and HL7 events.

In such a scenario, you would most likly be interesting in monitoring the following:

* Errors from any component.
* Loss of connection between the inbound and outbound systems.
* A large buildup in the processing queues.
* Lack of any message processing during some slice of time (for example, no messages for 2 hours).

The first three above are all supported in HealthShare out-of-the-box. For the last requirement,
we'll need to leverage the extensibility of HealthShare to build our own component to monitor
the lack of any message throughput.

We'll utilize the built-in support for sending emails as a way to handle alerts.



