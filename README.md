A hands on demonstration of HealthShare

Preparation
- Fire up an EC2 node, open up the AWS firewall appropriately - 1972,57772,9980-9980
- Get the HS install kit you want on the box
- Prepare some HL7 Messages on your local machine
- Build a data transform from an HL7 message to a SDA XML


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
'''
nc -k -vv -l 8888 
'''
to start listening

- Start up the production
- From your laptop, cd into directory with HL7 messages
- here is how to send hl7 to the HTTP service

'''
 find . -name "*.hl7" -print0 | xargs -0 -P 4 -I file curl -v -X POST localhost:9980 --data-binary @file
'''

Now - go back to SMP
- Show message tracing
- Add in the data transform - hosted in github, download with browser and then show studio to import the transform
- Go into your production add the transform, make the inbound service send hl7 through it
- Configure outbound TCP service

Add in an EnsLib.TCP.PassthroughOperation, import in the Demo.SDAGenerator from github - configure them

