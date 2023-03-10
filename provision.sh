## create sns
TOPIC_ARN=`aws sns create-topic --name health_checking --query 'TopicArn' --output text`

## subscribe sns topic
SUB_ARN=`aws sns subscribe --topic-arn $TOPIC_ARN --protocol email --notification-endpoint brodavlad@gmail.com --query 'SubscriptionArn' --output text`

## setup a cloudwatch
aws cloudwatch put-metric-alarm --alarm-name health_checking --alarm-description "Instance deleted." --metric-name HealthyHostCount \
    --namespace AWS/ApplicationELB --statistic Average --period 60 --threshold 2 --comparison-operator LessThanThreshold \
    --dimensions Name=TargetGroup,Value=targetgroup/TargetGroup/4de190e145ab5b25 Name=LoadBalancer,Value=app/my-load-balancer/5d014842c45122d2 \
    --evaluation-periods 1 --alarm-actions $TOPIC_ARN
