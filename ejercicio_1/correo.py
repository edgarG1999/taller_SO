#!/usr/bin/env python3
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import argparse
from datetime import datetime

def enviar_correo(asunto="Backup Diario", cuerpo="Backup completado"):
    senderEmail = "elguti1210@gmail.com"
    receiverEmail = "elguti1210@gmail.com"
    password = "rlag ohne hgmo rozc"

    message = MIMEMultipart()
    message["From"] = senderEmail
    message["To"] = receiverEmail
    message["Subject"] = asunto
    message.attach(MIMEText(cuerpo, "plain"))

    try:
        with smtplib.SMTP("smtp.gmail.com", 587) as server:
            server.starttls()
            server.login(senderEmail, password)
            server.sendmail(senderEmail, receiverEmail, message.as_string())
            print("Email enviado!")
            return True
    except Exception as e:
        print(f"fallo el envio: {e}")
        return False

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Enviar correo electrónico')
    parser.add_argument('--asunto', help='Asunto del correo', default="Backup Diario")
    parser.add_argument('--cuerpo', help='Cuerpo del correo', default=f"Backup completado el {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    args = parser.parse_args()
    enviar_correo(args.asunto, args.cuerpo)