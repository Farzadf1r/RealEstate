

class OTPRecipientWasWrongFormatted implements Exception
{
  String recipient = "";
  OTPRecipientWasWrongFormatted({this.recipient = ""});
}