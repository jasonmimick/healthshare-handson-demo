Alerting
========

Alerts provide a mechanism to manage and monitor your HealthShare productions.
Every component supports alerting - the functionality is baked into the
base service/process/operations classes.

There are two "modes" for handling alerts within HealthShare - Basic Alerting or
Alert Management. The later, is a new feature and allows for more customization of the
alerting system. This note will cover the prior - basic alerting.

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
Your application uses HealthShare to process an inbound HL7 feed. This processing includes 
conversion of the HL7 into CDA documents which then get sent off to a downstream
repository. You also send off statistics of the incoming HL7 to a custom application
which keeps track of basic patient demographics and HL7 events.

In such a scenario, you would most likly be interesting in monitoring the following:

* Errors from any component.
* Loss of connection between the inbound and outbound systems.
* A large buildup in the processing queues.
* Lack of any message processing during some slice of time (for example, no messages for 30 minutes).

These requirements are all supported in HealthShare out-of-the-box.

We'll utilize the built-in support for sending emails as a way to handle alerts.

In your production, add an EnsLib.EMail.AlertOperation. Name the new component "Ens.Alert" - 
this is important, by default the runtime will route any alert raised by a component in 
the production to the component called "Ens.Alert".

To configure your email alert component you'll need to, probably, setup an SSL configuration
and also enter in a set of Credentials - these are needed in the settings for the
email operation. You'll also need to enter the SMTP server and port and the email
addresses of those you wish to receive the alerts. A good practice is to setup some
email aliases to act as groups so you don't need to enter many addresses here. For example,
setup an alias called "healthshare-alerts" in your email system and use that in the 
component. 

Next, for each component you wish to monitor there is a section called "Alerting Control"
on the Settings tab. Here you can configure when alerts should get raised. We'll make the 
following changes to satisfy our requirements.

* For services - check "Alert On Error"
* For processes and operations, check "Alert On Error" and provide a value in the "Queue
Count Alert" - let's say 20.
* For any components dealing with TCP networking, configure the "Inactivity Timeout" to be
600 - that's 30 minutes in seconds.

That is all you need. To test things out we can use the built-in testing service.
First, enable testing on the production - this is towards the botton on the Production Settings.
Then, select the Ens.Alert component and click the "Test" button on the "Actions" tab.
For the request, select Ens.AlertRequest from the drop down. Then enter in some text for the
testing message and click the "Invoke Testing Service" button. You should get an email at the
address configured in the EmailOperation.

For further details, please consult the on-line documentation embedded in your HealthShare 
instance. Happy Alerting!

