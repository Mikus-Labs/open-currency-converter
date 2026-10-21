# Switches the Runner target's Release configuration to manual signing with
# the given team and App Store provisioning profile, so CI can archive without
# an Apple ID signed in to Xcode.
#
# Usage: ruby configure_ios_signing.rb <path/to/Runner.xcodeproj> <team id> <profile name>
require 'xcodeproj'

project_path, team_id, profile_name = ARGV
abort 'usage: configure_ios_signing.rb <xcodeproj> <team id> <profile name>' unless profile_name

project = Xcodeproj::Project.open(project_path)
runner = project.targets.find { |t| t.name == 'Runner' } or abort 'Runner target not found'
release = runner.build_configurations.find { |c| c.name == 'Release' } or abort 'Release configuration not found'

settings = release.build_settings
settings['CODE_SIGN_STYLE'] = 'Manual'
settings['DEVELOPMENT_TEAM'] = team_id
settings['PROVISIONING_PROFILE_SPECIFIER'] = profile_name
settings['CODE_SIGN_IDENTITY'] = 'Apple Distribution'
settings['CODE_SIGN_IDENTITY[sdk=iphoneos*]'] = 'Apple Distribution'

project.save
puts "Runner/Release: manual signing, team #{team_id}, profile '#{profile_name}'"
