SessionID's in Ensemble
-----------------------

Certain data processing scenarios in Ensemble need the ability to access messages
from previous steps in the pipeline. This is possible with some coding.

To start - all the messages for a session are all linked in their message headers
with a common SessionId. To access this value, you can use the following macro:

```
$$$JobSessionId
```

(defined in Ensemble.inc). This macro can be used directly in BPLs, services, operations, or
data transformations.

Once you have access to the session id, then you need to query the Ensemble messaging
data tables to get the message data.

At the base level - you need a query:

```
select MessageBodyId,MessageBodyClassName from Ens.MessageHeader where SessionId = <your session id>
```

This will give you 2 things - the type for the message and a primary key to fetch it
out of the db.
Now, we're ready to fetch the data - for that a little ObjectScript:

```
set message = ##class(<some message body class name>).%OpenId(<some message body id>)
```

Getting the raw message data depends on the type of your message body.
For example if you have an Ens.StreamContainer, then that object will have a Stream
property which you can use to read out the raw message.

There are additional items available in the Ens.MessageHeader. A given session will most
likey have multiple messages flowing betweeing the components. You can query the SourceConfigName
and the TargetConfigName columns to find a particular message from the pipeline.



