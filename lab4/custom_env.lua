local cjson = require('cjson')
local PolicyChain = require('apicast.policy_chain')
local policy_chain = context.policy_chain

local logging_policy_config = cjson.decode([[
{
  "enable_access_logs": false,
  "custom_logging": "[{{time_local}}] IP:{{req.headers.x-forwarded-for |json}}
ApiTxno:{{req.headers.api_txno}} TraceID:{{req.headers.uber-trace-id}}
ServiceName:{{service.system_name}} PublicURL:{{req.headers.x-forwarded-
host|json}} RequestPath:{{request}} StatusCode:{{status}}
RequestID:{{request_id}} BodyLength:{{body_bytes_sent}}
RequestTime:({{request_time}}) ResponseTime:{{upstream_response_time}}
PostActionImpact:{{post_action_impact}}"

}
]])

policy_chain:insert( PolicyChain.load_policy('logging', 'builtin', logging_policy_config), 1)

return {
  policy_chain = policy_chain,
  port = { metrics = 9421 },
}

