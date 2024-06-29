from azure.cognitiveservices.vision.computervision import ComputerVisionClient
from azure.cognitiveservices.vision.computervision.models import OperationStatusCodes
from msrest.authentication import CognitiveServicesCredentials
import time
def extract_text_from_image(subscription_key, endpoint, image_url):
    # Create a ComputerVisionClient
    computervision_client = ComputerVisionClient(endpoint, CognitiveServicesCredentials(subscription_key))
   
    # Call API to extract text
    read_response = computervision_client.read(image_url, raw=True)
   
    # Get the operation location (URL with an ID at the end) from the response
    read_operation_location = read_response.headers["Operation-Location"]
    operation_id = read_operation_location.split("/")[-1]
   
    # Wait for the operation to complete
    while True:
        read_result = computervision_client.get_read_result(operation_id)
        if read_result.status not in [OperationStatusCodes.not_started, OperationStatusCodes.running]:
            break
        time.sleep(1)
   
    # Print the detected text in a structured format
    if read_result.status == OperationStatusCodes.succeeded:
        text_output = ""
        for text_result in read_result.analyze_result.read_results:
            for line in text_result.lines:
                text_output += f"{line.text}\n"
# Format the output text
   
        formatted_output = format_text(text_output)
        #print(formatted_output)
        return formatted_output
def format_text(text):
    # Basic formatting rules for demonstration
    lines = text.split('\n')
    formatted_lines = []
    for line in lines:
        if line.strip():
            if line.endswith(':'):
                formatted_lines.append(f"\n{line}\n{'=' * len(line)}\n")  # Treat lines ending with ':' as headings
            else:
                formatted_lines.append(f". {line}")  # Treat other lines as bullet points
    return '\n'.join(formatted_lines)
# Replace with your Computer Vision subscription key and endpoint
#subscription_key = "1d57401c18f347d180f929df08e44791"
#endpoint = "https://enterprisesearch.cognitiveservices.azure.com/"
#blob_url="https://rgchatbotapplicatioac41.blob.core.windows.net/images1/image5.jpg"
#extract_text_from_image(subscription_key, endpoint, blob_url)