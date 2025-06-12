Class Demo.person Extends (%Persistent, %Library.Populate)
{

Property Name As %String(MAXLEN = 50);

// Make Age a calculated field

Property Age As %Integer [ Calculated, SqlComputeCode = {SET {Age}=##class(Demo.person).CalculateAge({DateOfBirth})}, SqlComputed ];

Property Email As %String(MAXLEN = 100);

Property DateOfBirth As %Date;

// Method to calculate age from DOB

ClassMethod CalculateAge(pDOB As %Date) As %Integer
{
    If pDOB = "" Quit ""
    
    Set today = $PIECE($HOROLOG,",",1)
    Set age = (today - pDOB) \ 365.25
    
    Quit age
}

/// Returns the count of person records
ClassMethod Count() As %Integer
{
    Set count = 0
    &sql(
        SELECT COUNT(*) INTO :count 
        FROM Demo.person
    )
    Quit count
}

Storage Default
{
<Data name="personDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Age</Value>
</Value>
<Value name="4">
<Value>Email</Value>
</Value>
<Value name="5">
<Value>DateOfBirth</Value>
</Value>
</Data>
<DataLocation>^Demo.personD</DataLocation>
<DefaultData>personDefaultData</DefaultData>
<IdLocation>^Demo.personD</IdLocation>
<IndexLocation>^Demo.personI</IndexLocation>
<StreamLocation>^Demo.personS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
