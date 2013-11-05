module MGit
  class FetchCommand < Command
    def execute(args)
      raise TooManyArgumentsError.new(self) if args.size != 0

      Registry.chdir_each do |repo|
        `git remote`.split.each do |remote|
          puts "Fetching #{remote} in repository #{repo.name}...".yellow
          `git fetch #{remote}`
        end
      end
    end

    def usage
      'fetch'
    end

    def description
      'fetch all remote repositories'
    end

    register_command :fetch
  end
end
