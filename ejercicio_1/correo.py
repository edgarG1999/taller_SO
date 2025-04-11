import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

subject = "titulo"
body = "mensaje"

senderEmail = "elguti1210@gmail.com"
receiverEmail = "elguti1210@gmail.com"
password = "rlag ohne hgmo rozc"

message = MIMEMultipart()
message["From"] = senderEmail
message["To"] = receiverEmail
message["Subject"] = subject
message.attach(MIMEText(body, "plain"))

try:
  with smtplib.SMTP("smtp.gmail.com", 587) as server:
    server.starttls()
    server.login(senderEmail, password)
    server.sendmail(senderEmail, receiverEmail, message.as_string())
    print("Email enviado!")
except Exception as e:
  print(f"fallo el envio: {e}")
