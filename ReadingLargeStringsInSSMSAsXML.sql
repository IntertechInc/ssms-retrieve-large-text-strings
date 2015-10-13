--NOTE: For most of these any CDATA section references are replaced with the content of the CDATA section
--example: <root><![CDATA[This is CDATA section content]]></root>
--becomes: <root>This is CDATA section content</root>

--Wraps text into CDATA section as encoded text. Useful for querying large non-XML strings. 
SELECT Id, CAST('<xml><![CDATA[' + [LargeColumn] + ']]></xml>' AS XML) AS LargeColumnAsXml
FROM [TableWithLargeColumn]

--This option works for obscure data with DTD's in them. Seems to be the best overall option, but takes longer to run
SELECT Id, CONVERT(XML, [LargeColumn], 2) as LargeColumnAsXml
FROM [TableWithLargeColumn]

-- Good for XML columns stored as strings. 
-- Does not seem to like internal DTD subsets -- error suggests using CONVERT with style option 2 (see above example)
SELECT Id, CAST([LargeColumn] AS XML) as LargeColumnAsXml
FROM [TableWithLargeColumn]

--THIS CONCATENATES THE ENTIRE RESULT AN XML Processing Instructions - SOMETIMES ENDS UP BEING TOO LARGE
--See StackOverflow article http://stackoverflow.com/questions/12639948/sql-nvarchar-and-varchar-limits
SELECT Id, [LargeColumn] as [processing-instruction(x)]
FROM [dbo].[TableWithLargeColumn]
FOR XML PATH 

 --For TRIMMING the xml version header prior to cast - i.e. <?xml version="1.0" encoding="UTF-8" ?> instruction
 --Extrapolate as necessary
 --String search could be used here too
SELECT CAST(REPLACE(LargeColumn, '<?xml version="1.0" encoding="UTF-8"?>', '') AS XML)
FROM TableWithLargeColumn

