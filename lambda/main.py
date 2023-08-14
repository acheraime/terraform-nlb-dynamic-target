import logging
import json
import os
import sys 

from botocore.exceptions import ClientError
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

from utils.validator import validate_and_set_var
from utils.error import MissingVariableError
from utils.loadbalancer import LBTargetGroup

# Instantiate a logger
logger = logging.getLogger(name=__name__)

try:
    LB_TARGET_GROUP_ARN, RDS_HOST_FQDN = validate_and_set_var()
except MissingVariableError as err:
    logger.error(err)
    sys.exit(1)
    
LOG_LEVEL = os.environ.get('LAMBDA_LOG_LEVEL', 'info')
SLACK_TOKEN = os.environ.get('SLACK_TOKEN')
SLACK_CHANNEL = os.environ.get('SLACK_CHANNEL')

logger.setLevel(logging.getLevelName(LOG_LEVEL.upper()))

SEND_SLACK = False
if SLACK_TOKEN and SLACK_CHANNEL:
    SEND_SLACK = True
    # Instantiate slack client
    slack_client = WebClient(SLACK_TOKEN)

def handler(e, ctx):
    """
    Lambda function entrypoint that handles the logic to
    update the loadbalancer target group target IPs as follow:
    1 - We ensure that this function has been invoked by a valid RDS event
    2 - Then we verify the currently IPs that are attached to the LB
    3 - We resolve the rds hostname and compare the IP to the ones
    4 - If the IPs are the same we stop here else we continue to the next step
    5 - Deregister the old IP from the taget group
    6 - Register the new IP to the target
    """
    # Prep work
    event_json = json.dumps(e)
    logger.debug(f"LB_TARGET_GROUP_ARN: {LB_TARGET_GROUP_ARN}")
    logger.debug(f"RDS_HOST_FQDN: {RDS_HOST_FQDN}")
    logger.debug(f"Received events: {event_json}")

    # Instantiate a LBTargetGroup
    try:
        lb_target_group = LBTargetGroup(
            arn=LB_TARGET_GROUP_ARN,
        )
        lb_target_group.set_targets(RDS_HOST_FQDN)
        logger.debug(f"Load balancer current targets: {lb_target_group.current_target_ids}")
        logger.debug(f"Load balancer possible new targets: {lb_target_group.new_target_ids}")

        # Should we update the target group with
        if lb_target_group.to_be_updated:
            logger.debug("Target group needs to be updated with new targets")
            if lb_target_group.register_targets():
                msg = f"New targets registered to group {lb_target_group.new_target_ids}"
                logger.info()
                # Send slack messsage
                if SEND_SLACK:
                    try:
                        slack_client.chat_postMessage(channel=f"#{SLACK_CHANNEL}", text=msg)
                    except SlackApiError as err:
                        logger.warning(f"fail to post message to slack: {err}")
        else:
            logger.info("No new target to register")
            slack_client.chat_postMessage(channel=f"#{SLACK_CHANNEL}", text="No new target to register")
    except ClientError as err:
        logger.error(err)
        sys.exit(1)

    return {
        "environment": os.environ.get("AWS_REGION")
    }