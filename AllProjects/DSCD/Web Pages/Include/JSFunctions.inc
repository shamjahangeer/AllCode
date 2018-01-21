
<script language="javascript">
<!--

function clear_select(CS_select_in)     //javascript function
{
	while(CS_select_in.length > 0){
		CS_select_in.options[0] = null;
	}
}

function delete_option(DO_SelectIn, DO_IndexIn)     //javascript function
{
	DO_SelectIn.options[DO_IndexIn] = null;
}

function add_option(AO_SelectIn, AO_IndexIn, AO_TextIn, AO_ValueIn, AO_blnDefSelIn, AO_blnSelectedIn)     //javascript function
{
	AO_SelectIn.options[AO_IndexIn] = new Option(AO_TextIn, AO_ValueIn, AO_blnDefSelIn, AO_blnSelectedIn);
}

function get_index(arrayIn, valueIn)	//javascript function
{
	for(var GI_inx = 0;GI_inx < arrayIn.length;GI_inx++){
		if(arrayIn[GI_inx] == valueIn) return GI_inx;
	}
	return -1;
}

function push(arrayIn, valueIn)     //javascript function
{
	arrayIn[arrayIn.length] = valueIn;
}

function pop(arrayIn)     //javascript function
{
	var temp = arrayIn[(arrayIn.length - 1)];
	arrayIn[(arrayIn.length - 1)] = '';
	arrayIn.length--;

	return(temp);
}

function shift(arrayIn)     //javascript function
{
	var temp = arrayIn[0];
	var intLength = arrayIn.length;
	var tempInx;

	for(tempInx = 0; tempInx < (intLength - 1); tempInx++){
		arrayIn[tempInx] = arrayIn[tempInx + 1];
	}

	arrayIn[intLength - 1] = '';
	arrayIn.length--;

	return(temp);
}

function unshift(arrayIn, valueIn)     //javascript function
{
	var tempInx;
	var intLength = arrayIn.length;

	for(tempInx = intLength; tempInx >= 0; tempInx--){
		arrayIn[tempInx] = arrayIn[tempInx - 1];
	}

	arrayIn[0] = valueIn;
}

function IsValidDate(IVD_strDateIn){
/*************************************************************/
/*                                                           */
/*  IsValidDate                                              */
/*     Receives a string numeric representation of a date.   */
/*     Returns true if the string represents a valid date.   */
/*                                                           */
/*  NOTE:  This function currently only handles numeric date */
/*         representations.                                  */
/*                                                           */
/*      If you need to monkey with this, here are the        */
/*  customizable variables.                                  */

	var IVD_intYYYY	= 0;  //	\
	var IVD_intMM	= 1;  //	 -( Sets order of date parts - use as indexes for IVD_strTestDateArray
	var IVD_intDD	= 2;  //	/

	var IVD_strSeparator = '-';				//	Sets the symbol that separates the date parts

	var IVD_blnAllowFutureDates	= true; 	//  Whether dates beyond the system date are valid
	var IVD_blnAllowPastDates	= true; 	//  Whether dates before the system date are valid
											//  If both of these are false then the date will
											//	never be valid.
	var IVD_intFutureLimit		= 10;		//  Future # of years that are valid
	var IVD_intPastLimit		= 10;		//  Past # of years that are valid

	var IVD_intYearDigits = 4;	//	# of digits expected in year

/*************************************************************/

	var IVD_dtTemp	= new Date();
	var IVD_dtToday	= new Date(IVD_dtTemp.getFullYear(), IVD_dtTemp.getMonth(), IVD_dtTemp.getDate());
	var IVD_strTestDateArray = IVD_strDateIn.split(IVD_strSeparator);

	var IVD_blnIsValidDate	= false;

	if (
		(IVD_strTestDateArray.length == 3) &&
		(IVD_strTestDateArray[IVD_intYYYY].length == IVD_intYearDigits) &&
		(IVD_strTestDateArray[IVD_intYYYY] <= (Number(IVD_dtToday.getFullYear()) + IVD_intFutureLimit)) &&
		(IVD_strTestDateArray[IVD_intYYYY] >= (Number(IVD_dtToday.getFullYear()) - IVD_intPastLimit))
	   ){

		IVD_dtTestDate = new Date(IVD_strTestDateArray[IVD_intYYYY], IVD_strTestDateArray[IVD_intMM] - 1, IVD_strTestDateArray[IVD_intDD]);

        IVD_switchvar = 0

		IVD_blnIsValidDate = false;

        switch(IVD_switchvar){
		case 0:
			if (!(
			(IVD_dtTestDate.getDate() == IVD_strTestDateArray[IVD_intDD]) &&
			((IVD_dtTestDate.getMonth() + 1) == IVD_strTestDateArray[IVD_intMM]) &&
			(IVD_dtTestDate.getFullYear() == IVD_strTestDateArray[IVD_intYYYY])
			))
			{
				break;
			}

			if ((!(IVD_blnAllowPastDates)) && (IVD_dtTestDate < IVD_dtToday)){
				break;
			}

			if ((!(IVD_blnAllowFutureDates)) && (IVD_dtTestDate > IVD_dtToday)){
				break;
			}
		default:
			IVD_blnIsValidDate = true;
	}	}

	return IVD_blnIsValidDate;
}

// -->
</script>
