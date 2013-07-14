require "jenkins_api_client"

module JenkinsApi
  class Client
    class Job
      def build_freestyle_config(params)
        # Supported SCM providers
        supported_scm = ["git", "subversion", "cvs"]

        # Set default values for params that are not specified.
        raise ArgumentError, "Job name must be specified" \
          unless params.is_a?(Hash) && params[:name]
        if params[:keep_dependencies].nil?
          params[:keep_dependencies] = false
        end
        if params[:block_build_when_downstream_building].nil?
          params[:block_build_when_downstream_building] = false
        end
        if params[:block_build_when_upstream_building].nil?
          params[:block_build_when_upstream_building] = false
        end
        params[:concurrent_build] = false if params[:concurrent_build].nil?
        if params[:notification_email]
          if params[:notification_email_for_every_unstable].nil?
            params[:notification_email_for_every_unstable] = false
          end
          if params[:notification_email_send_to_individuals].nil?
            params[:notification_email_send_to_individuals] ||= false
          end
        end
        # SCM configurations and Error handling.
        unless supported_scm.include?(params[:scm_provider]) ||
          params[:scm_provider].nil?
          raise "SCM #{params[:scm_provider]} is currently not supported"
        end
        if params[:scm_url].nil? && !params[:scm_provider].nil?
          raise 'SCM URL must be specified'
        end
        if params[:scm_branch].nil? && !params[:scm_provider].nil?
          params[:scm_branch] = "master"
        end
        if params[:scm_use_head_if_tag_not_found].nil?
          params[:scm_use_head_if_tag_not_found] = false
        end

        # Child projects configuration and Error handling
        if params[:child_threshold].nil? && !params[:child_projects].nil?
          params[:child_threshold] = 'failure'
        end

        @logger.debug "Creating a freestyle job with params: #{params.inspect}"

        # Build the Job xml file based on the parameters given
        builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') { |xml|
          xml.project {
            xml.actions
            xml.description
            xml.keepDependencies "#{params[:keep_dependencies]}"
            xml.properties
            # SCM related stuff
            if params[:scm_provider] == 'subversion'
              # Build subversion related XML portion
              scm_subversion(params, xml)
            elsif params[:scm_provider] == "cvs"
              # Build CVS related XML portion
              scm_cvs(params, xml)
            elsif params[:scm_provider] == "git"
              # Build Git related XML portion
              scm_git(params, xml)
            else
              xml.scm(:class => "hudson.scm.NullSCM")
            end
            # Restrict job to run in a specified node
            if params[:restricted_node]
              xml.assignedNode "#{params[:restricted_node]}"
              xml.canRoam "false"
            else
              xml.canRoam "true"
            end
            xml.disabled "false"
            xml.blockBuildWhenDownstreamBuilding(
              "#{params[:block_build_when_downstream_building]}")
            xml.blockBuildWhenUpstreamBuilding(
              "#{params[:block_build_when_upstream_building]}")
            if params[:timer]
              xml.triggers.vector {
                xml.send("hudson.triggers.TimerTrigger") {
                  xml.spec params[:timer]
                }
              }
            else
              xml.triggers.vector
            end
            xml.concurrentBuild "#{params[:concurrent_build]}"
            # Shell command stuff
            xml.builders {
              if params[:shell_command]
                xml.send("hudson.tasks.Shell") {
                  xml.command "#{params[:shell_command]}"
                }
              end
            }
            # Adding Downstream projects
            xml.publishers {
              # Build portion of XML that adds child projects
              child_projects(params, xml) if params[:child_projects]
              # Build portion of XML that adds email notification
              notification_email(params, xml) if params[:notification_email]
              # Build portion of XML that adds skype notification
              skype_notification(params, xml) if params[:skype_targets]
            }
            xml.buildWrappers
          }
        }
        builder.to_xml
      end

      def create_freestyle(params)
        xml = build_freestyle_config(params)
        create(params[:name], xml)
      end

      def update_freestyle(params)
        xml = build_freestyle_config(params)
        post_config(params[:name], xml)
      end

      def create_or_update_freestyle(params)
        if exists?(params[:name])
          update_freestyle(params)
        else
          create_freestyle(params)
        end
      end
    end
  end
end
