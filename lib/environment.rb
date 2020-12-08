require "httparty"
require "net/http"
require "pry"
require "dotenv"
Dotenv.load

require_relative "./planner/version"
require_relative "./planner/api"
require_relative "./planner/cli"
require_relative "./planner/meal"
require_relative "./planner/ingredient"

