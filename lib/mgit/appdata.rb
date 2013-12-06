require 'yaml'

module MGit
  module AppData

    ####################
    # Module interface #
    ####################

    def self.update
      AppDataVersion.updates.each { |u| u.migrate! }
    end

    def self.load(key, default = {})
      AppDataVersion.current.load(key, default)
    end

    def self.save!(key, value)
      AppDataVersion.current.save!(key, value)
    end

    #########################################
    # Base class for data storage versions. #
    #########################################

    class AppDataVersion
      @@versions = []

      def self.inherited(version)
        @@versions << version.new
        super
      end

      def self.sorted
        @@versions.sort_by { |v| v.version }
      end

      def self.updates
        self.sorted.drop_while { |v| !v.active? }.drop(1)
      end

      def self.current
        self.sorted.last
      end

      include Comparable

      def <=>(other)
        version <=> other.version
      end

      [:version, :active?, :load, :save!, :migrate!].each do |meth|
        define_method(meth) do
          raise ImplementationError.new("AppDataVersion #{self.class.name} doesn't implement the #{meth.to_s} method.")
        end
      end
    end

    #######################################################################
    # Original version, plain YAML file containing the repositories hash. #
    #######################################################################

    class LegacyAppData < AppDataVersion
      def version
        0
      end

      def active?
        File.file?(repofile)
      end

      def load(key, default)
        raise ImplementationError.new('LegacyAppData::load called with unknown key.') if key != :repositories
        YAML.load_file(repofile)
      end

      def save!(key, value)
        raise ImplementationError.new('LegacyAppData::save! called with unknown key.') if key != :repositories
        File.open(repofile, 'w') { |fd| fd.write value.to_yaml }
      end

    private

      def repofile
        XDG['CONFIG_HOME'].to_path.join('mgit.yml')
      end
    end

  end
end