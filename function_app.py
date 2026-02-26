import logging
import azure.functions as func
import os
import requests
import time
import json
from azure.storage.blob import BlobServiceClient
from datetime import datetime

app = func.FunctionApp()

@app.blob_trigger(
    arg_name="blob",
    path="images/{name}",
    connection="AzureWebJobsStorage"
)
def ocr_function(blob: func.InputStream):

    logging.info(f"Processing blob: {blob.name}")

    endpoint = os.environ["VISION_ENDPOINT"]
    key = os.environ["VISION_KEY"]

    image_bytes = blob.read()

    # === Envoi image pour OCR ===
    ocr_url = f"{endpoint}/vision/v3.2/read/analyze"

    headers = {
        "Ocp-Apim-Subscription-Key": key,
        "Content-Type": "application/octet-stream"
    }

    response = requests.post(ocr_url, headers=headers, data=image_bytes)

    if response.status_code != 202:
        logging.error("OCR request failed")
        return

    operation_url = response.headers["Operation-Location"]

    # === Polling résultat ===
    analysis = {}
    while True:
        result_response = requests.get(operation_url, headers=headers)
        analysis = result_response.json()

        if analysis["status"] not in ["notStarted", "running"]:
            break

        time.sleep(1)

    if analysis["status"] != "succeeded":
        logging.error("OCR processing failed")
        return

    # === Extraction du texte ===
    extracted_text = ""

    for page in analysis["analyzeResult"]["readResults"]:
        for line in page["lines"]:
            extracted_text += line["text"] + "\n"

    # === Création JSON résultat ===
    output = {
        "file_name": blob.name,
        "extracted_text": extracted_text.strip(),
        "timestamp": datetime.utcnow().isoformat()
    }

    # === Sauvegarde dans container results ===
    blob_service = BlobServiceClient.from_connection_string(
        os.environ["AzureWebJobsStorage"]
    )

    result_blob = blob_service.get_blob_client(
        container="results",
        blob=blob.name.replace(".jpg", ".json")
    )

    result_blob.upload_blob(
        json.dumps(output),
        overwrite=True
    )

    logging.info("OCR processing completed successfully.")