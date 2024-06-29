
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient
from ExtractTextFromImage import extract_text_from_image
from flask import Flask, request, jsonify
from getIngrediateDetails import extract_ingredients
from summerizeTheDetails import summerize
import os
app = Flask(__name__)
subscription_key = ""
endpoint = ""
connection_string = ''
blob_name = '' # You can use the image file name or any other desired name
container_name = ''
text1=''
text2=''
def upload_to_blob_storage(connection_string, container_name, file_path):
# Create a BlobServiceClient using the connection string
    blob_service_client = BlobServiceClient.from_connection_string(connection_string)

# Create a ContainerClient
    container_client = blob_service_client.get_container_client(container_name)

# Create a container if it doesn't exist
    if not container_client.exists():
        container_client.create_container()

    blob_client = container_client.get_blob_client(os.path.basename(file_path))

    with open(file_path, "rb") as data:
        blob_client.upload_blob(data, overwrite=True)
# Upload the file

    print(f"File {file_path} uploaded to Blob Storage.")
    return blob_client.url

@app.route('/uploadIngredients', methods=['POST'])
def upload_image(file_path):
    blob_url = upload_to_blob_storage(connection_string, container_name, file_path)
    extracted_text = extract_text_from_image(subscription_key, endpoint, blob_url)
    ingredients=extract_ingredients(extracted_text)
    return jsonify({"ingredients": ingredients})


@app.route('/uploadProfile', methods=['POST'])
def upload_profile(file_path):
    blob_url = upload_to_blob_storage(connection_string, container_name, file_path)
    extracted_text = extract_text_from_image(subscription_key, endpoint, blob_url)
    return jsonify({"extracted_text": extracted_text})

@app.route('/summerize', methods=['POST'])
def summerization():  
    text1=request.get_json()['Ingredients']
    text2=request.get_json()['Disease']
    text3=request.get_json()['Health report']
    return jsonify({"result":summerize(text2,text1, text3)})
if __name__ == '__main__':
    if not os.path.exists('uploadProfile'):
        os.makedirs('uploadProfile')
    app.run(debug=True)
