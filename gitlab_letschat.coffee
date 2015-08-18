# Description:
#   GitLab to Let's Chat notification
#
# Dependencies:
#   "url" : ""
#   "querystring" : ""
#
# Configuration:
#   None
#
# Commands:
#   None
#
# URLS:
#   /gitlab/webhook
#
# Auther:
#   hideakihal 

GITLAB_URL = 'http://192.168.56.13'  #replace your GitLab URL
url = require 'url'
querystring = require 'querystring'

module.exports = (robot) ->

  merge_request = (json) ->
    username = "#{json.user.name}"
    title = "#{json.object_attributes.title}"
    iid = "#{json.object_attributes.iid}"
    namespace = "#{json.object_attributes.source.namespace}".toLowerCase()
    name = "#{json.object_attributes.source.name}".toLowerCase()
    url = "#{GITLAB_URL}/#{namespace}/#{name}/merge_requests/#{iid}" 
    message = """
              [#{namespace}/#{name}] Merge Request created by #{username} 
              ##{iid} #{title}
              #{url}
              """
    robot.send {room: "55d071c4a37649f91bb61e60"}, message #replace your Let's Chat room id
    #robot.logger.info message

  robot.router.post "/gitlab/webhook", (req, res) ->
    hook = req.body
    kind = hook['object_kind'] || 'push'
    if kind is "merge_request"
        merge_request hook
    res.end()
