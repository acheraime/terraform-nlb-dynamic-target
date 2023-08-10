import boto3
import dns.resolver

from collections import Counter
from dns.resolver import NXDOMAIN, NoNameservers
from botocore.exceptions import ClientError
from dataclasses import dataclass, field
from typing import Any

def targets() -> Any:
    target_list = []


    return target_list

try:
    client = boto3.client('elbv2')
except ClientError:
    raise ClientError

# Build the LBTarget class
@dataclass
class LBTargetGroup:
    """ This class models the loadbalancer target group """
    arn: str
    current_target_ids: list = field(default_factory=list)
    new_target_ids: list = field(default_factory=list)
    to_be_updated: bool = False

    def __post_init__(self):
        """ 
        Inspect the target group to populate current_target_ids attribute
        """
        try:
            lbtg_attr = client.describe_target_health(TargetGroupArn=self.arn)
            for target in lbtg_attr['TargetHealthDescriptions']:
                self.current_target_ids.append(target['Target']['Id'])
        except ClientError:
           raise 

    def set_targets(self, host: str):
        """
        Register IP address provided in the host parameter to the target group.
        """
        try:
            r = dns.resolver.resolve(host, 'A')
            for ip in r:
                self.new_target_ids.append(ip.to_text())
        except (NXDOMAIN, NoNameservers) as err:
            raise Exception(err.msg)
        
        if Counter(self.current_target_ids) != Counter(self.new_target_ids):
            # The old targets are different then the new ones
            self.to_be_updated = True

    def register_targets(self) -> bool:
        """
        register_targets unregister old targets from load balancer then registers new ones
        """
        if not self.to_be_updated:
            return False
        bad_target_ids = []
        for id in self.current_target_ids:
            bad_target_ids.append({
                'Id': id
            })
        if self.current_target_ids:
            try:
                r = client.deregister_targets(
                    TargetGroupArn=self.arn,
                    Targets=bad_target_ids
                )
            except ClientError as err:
                raise Exception(err.msg)
        
        # register new targets
        new_target_ids = []
        for nt in self.new_target_ids:
            new_target_ids.append({
                'Id': nt
            })
        try:
            r = client.register_targets(
                TargetGroupArn=self.arn,
                Targets=new_target_ids
            )
        except ClientError as err:
            raise Exception(err.msg)
        
        return True