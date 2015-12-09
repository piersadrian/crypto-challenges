module CryptoChallenges
  class Set
    attr_reader :number, :name, :challenges

    def initialize(number, name)
      @number, @name = number, name
      @challenges = []
    end

    def add_challenge(name, &block)
      challenge = Challenge.new(@challenges.count + 1, name, &block)
      @challenges << challenge
    end

    def run_challenges!
      print_description
      challenges.each(&:run!)
    end

    def print_description
      puts
      puts name.upcase.magenta
      puts "-" * 30
    end
  end

  class Challenge
    attr_reader :number, :name

    def initialize(number, name, &block)
      @number, @name, @block, = number, name, block
    end

    def run!
      result = @block.call
      puts result == true ? description.green : description.red
    end

    def description
      "  ##{number}: #{name}"
    end
  end

  module DSL
    attr_reader :sets

    def set(name, &block)
      set = Set.new(sets.count + 1, name)
      @sets << set
      yield
      set.run_challenges!
    end

    def challenge(name, &block)
      return unless current_set
      current_set.add_challenge(name, &block)
    end

    def current_set; sets.last    end
    def sets;        @sets ||= [] end
  end
end

include ::CryptoChallenges::DSL
