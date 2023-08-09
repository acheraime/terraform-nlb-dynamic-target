import os

from .error import MissingVariableError

LB_TARGET_GROUP_ARN = None
RDS_HOST_FQDN = None

def set_variables():
# Check that environment variables are  properly set
    try:
        LB_TARGET_GROUP_ARN = os.environ['LB_TARGET_GROUP_ARN']
    except KeyError:
        raise MissingVariableError("LB_TARGET_GROUP_ARN")

    try:
        RDS_HOST_FQDN = os.environ['RDS_HOST_FQDN']
    except KeyError:
        raise MissingVariableError("RDS_HOST_FQDN")
    
    LOG_LEVEL = os.environ.get('LAMBDA_LOG_LEVEL', 'info')

    return LB_TARGET_GROUP_ARN, RDS_HOST_FQDN, LOG_LEVEL