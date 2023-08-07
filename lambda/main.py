import logging
import json
import os

# Instantiate a logger
logger = logging.getLogger(name=__name__)
logger.setLevel(logging.INFO)

def handler(e, ctx):
    """
    Lambda function entrypoint
    """
    events_json = json.dumps(e)
    logger.info(f"Received events: {events_json}")

    return {
        "environment": os.environ.get("AWS_REGION")
    }