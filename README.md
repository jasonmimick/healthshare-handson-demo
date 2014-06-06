A hands on demonstration of HealthShare

This demo will walkthrough installing and setting up some basic data processing 
with HealthShare.
Sample HL7 is included, to start you will setup a simple 'passthrough' production
to which you use curl to send HL7 and then push the HL7 out over a socket to a listener
on another machine. From this you will have a rich set of message traces to show and
use to describe the virtual document architecture.

Then, we showcase some of the development aspects by downloading and installing
a simple components from github which will highlight the native clinical data model 
by converting the HL7 into SDA on the fly.

Finally, the data transformation capabilities are shown where we take the SDA
stream and populate a custom data table. (not sure on this part yet)

Preparation
- Fire up an EC2 node, open up the AWS firewall appropriately - 1972,57772,9980-9980
- Get the HS install kit you want on the box
- Prepare some HL7 Messages on your local machine (just clone this repo and unpack 'hl7')


Demo 
- Remote desktop to your node
- Kick off the install, while this is running you describe the various components
- Flip over and show a picture of what you’re going to be showing

One installed -
- Create a HS/ENS enabled namespace for your demo - call it whatever, ACMEDEMO
- Open a production add an inbound HL7 HTTP service - make sure Mesage Schema Catagory = 2.5
- Add an EnsLib.TCP.PassthroughOperation pointing to healthshare.us 8888 - uncheck the "Get Reply"
- Have a horizontally split terminal session - one will connect to healthshare.us to listen for message, in the other you will send hl7 up to the new EC2 node
- Fire up ssh to healthshare.us kick off then start 
```bash
nc -k -vv -l 8888 
```
to start listening

- Start up the production
- From your laptop, cd into directory with HL7 messages
- here is how to send hl7 to the HTTP service

```bash
 find . -name "*.hl7" -print0 | xargs -0 -P 4 -I file curl -v -X POST localhost:9980 --data-binary @file
```

Now - go back to SMP
- Show message tracing
- Add in the data transform - hosted in github, download with browser and then show studio to import the transform
- Go into your production add the transform, make the inbound service send hl7 through it
- Configure outbound TCP service

Add in an EnsLib.TCP.PassthroughOperation, import in the Demo.SDAGenerator from github - configure them

