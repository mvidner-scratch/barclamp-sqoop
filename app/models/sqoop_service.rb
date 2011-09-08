#
# Cookbook Name: sqoop
# Recipe: sqoop_service.rb
#
# Copyright (c) 2011 Dell Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class SqoopService < ServiceObject
  
  def initialize(thelogger)
    @bc_name = "sqoop"
    @logger = thelogger
  end
  
  def create_proposal
    @logger.debug("sqoop create_proposal: entering")
    base = super
    
    # Get the node list, exclude the admin node.
    debug = true
    edge_nodes = Array.new
    nodes = NodeObject.all
    nodes.delete_if { |n| n.nil? or n.admin? }

=begin    
The code below doesn't work - can't use :node
    # Configuration filter for our environment
    env_filter = " AND environment:#{node[:sqoop][:config][:environment]}"
    
    # Find all edge nodes and attach the sqoop proposal to
    # those nodes. You need to have a Hadoop base edgenode
    # already or the proposal bind will fail.
    search(:node, "roles:hadoop-edgenode#{env_filter}") do |edge|
      if !edge[:fqdn].nil? && !edge[:fqdn].empty?
        Chef::Log.info("sqoop create_proposal: ADD EDGE_NODE [#{edge[:fqdn]}") if debug
        edge_nodes << nedge[:fqdn] 
      end
    end
=end
    
    # Check for errors or add the proposal elements
    base["deployment"]["sqoop"]["elements"] = { } 
    if edge_nodes.length == 0
      Chef::Log.info("sqoop create_proposal: No edge nodes found, proposal bind skipped")
    else
      base["deployment"]["sqoop"]["elements"]["sqoop-interpreter"] = edge_nodes 
    end
    
    # @logger.debug("sqoop create_proposal: #{base.to_json}")
    @logger.debug("sqoop create_proposal: exiting")
    base
  end
  
end
