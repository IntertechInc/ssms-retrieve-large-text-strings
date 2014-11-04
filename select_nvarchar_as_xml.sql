--This option works for obscure data with DTD's in them. Seems to be the best overall option, but takes longer to run
SELECT Id, TrackingId, len(requestxml), len(responsexml), CONVERT(XML, [RequestXml], 2) as LoanPayloadXml
FROM [Messages]

--This one occasionally has issues
--Wraps text in CDATA section for querying non-XML data.
SELECT Id, TrackingId, len(requestxml), len(responsexml), CAST('<xml><![CDATA[' + [RequestXml] + ']]></xml>' AS XML) AS XmlPayload
FROM [Messages]

-- This one doesn't seem to like internal DTD subsets -- error suggests using CONVERT with style option 2 (see above example)
SELECT Id, TrackingId, len(requestxml), len(responsexml), CAST([RequestXml] AS XML) as LoanPayloadXml
FROM [Messages]

--THIS ONE SEEMS TO CONCATENATE THE ENTIRE RESULT TO XML -- ENDS UP BEING TOO LARGE
--See StackOverflow article http://stackoverflow.com/questions/12639948/sql-nvarchar-and-varchar-limits
select Id, TrackingId, len(requestxml), len(responsexml), [RequestXml] as [processing-instruction(x)]
FROM [dbo].[Messages]
FOR XML PATH 

