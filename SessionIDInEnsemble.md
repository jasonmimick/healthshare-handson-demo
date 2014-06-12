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
For example, if you have an Ens.StreamContainer, then that object will have a Stream
property which you can use to read out the raw message.

There are additional items available in the Ens.MessageHeader. A given session will most
likey have multiple messages flowing betweeing the components. You can query the SourceConfigName
and the TargetConfigName columns to find a particular message from the pipeline.

One possible implementation strategy here would be to build an operation to which any component in 
your production could pass in a source and target and the operation would return the message
sent between those components in the current session.

A pseudo implementation of such an operation:

```
class Foo.FindMessageInSessionOperation extends Ens.BusinessOperation
{

method OnMessage(request as Foo.FindMessageInSessionRequest,
				 output response as Foo.FindMessageinSessionResponse) as %Status {
	if ( request.SourceConfigName = "" ) {
		return $$$ERROR("SourceConfigName is required")
	}
	if ( request.TargetConfigName = "" ) {
		return $$$ERROR("TargetConfigName is required")
	}
	set session=$$$JobSessionId
	if '(session?.N) {
		return $$$ERROR("Invalid session id '"_session_"' detected")
	}
	set rs=##class(%ResultSet).%New()
	try {
		set response=##class(Foo.FindMessageInSessionResponse).%New()
		set response.Status = "STARTED"
		$$$THROWONERROR(sc,rs.Prepare("select MessageBodyId, MessageBodyClassName from
									   Ens.MessageHeader where SessionID = ? and
									   SourceConfigName = ? and TargetConfigName = ?"))
		$$$THROWONERROR(sc,rs.Execute(session,request.SourceConfigName,request.TargetConfigName))
		/// There really should be one, but is more than one an error?
		/// Just log this
		set rowCount=0
		while ( rs.Next() ) {
			if ( rowCount>=1 ) {
				set rowCount=rowCount+1
				continue
			}
			set mbi=rs.Get("MessageBodyId")
			set mbcn=rs.Get("MessageBodyClassName")
			$$$TRACE("MessageBodyId="_mbi_" MessageBodyClassName="_mbcn)
			set message = $classmethod(mbcn,"%New",mbi)
			set response.Message=message
			set response.MessageBodyClassName=mbcn
			set response.MessageBodyId=mbi
			set response.Status="FOUND"
			set rowCount=rowCount+1
		}
		if ( rowCount = 0 ) {
			set response.Status = "NOTFOUND"
		}
		if ( rowCount > 1 ) {
			$$$LOGINFO("Found "_rowCount_" messages from "_SourceConfigName_" to "_TargetConfigName)
		}
	} catch error {
		return error.AsStatus()
	}
	quit $$$OK

}

class Foo.FindMessageInSessionRequest extends Ens.Request {

property SourceConfigName as %String;
property TargetConfigName as %String;
}

class Foo.FindMessageInSessionResponse extends Ens.Respose {

property Message as %RegisteredObject;
property MessageBodyClassName as %String;
property MessageBodyId as %String;
property Status as %String;

}
```


