describe ActionPolicy::Base do
  let(:user) { User.new }

  describe ".inherited" do
    it "sets default_resource to nil when class doesn't exist" do
      expect(EmptyPolicy.default_resource).to be_nil
    end

    it "sets default_resource to Class when class exists" do
      expect(SamplePolicy.default_resource).to be Sample
    end
  end

  describe ".new" do
    it "sets user" do
      policy = SamplePolicy.new(user)

      expect(policy.user).to be user
    end

    it "sets resource" do
      resource = double
      policy = SamplePolicy.new(user, resource)

      expect(policy.resource).to be resource
    end

    it "sets resource as default_resource when resource not specified" do
      policy = SamplePolicy.new(user)

      expect(policy.resource).to be SamplePolicy.default_resource
    end

    it "sets parent" do
      parent = double
      policy = SamplePolicy.new(user, nil, parent)

      expect(policy.parent).to be parent
    end

    it "sets parent and options when specified both" do
      parent = double
      options = { a: double }
      policy = SamplePolicy.new(user, nil, parent, options)

      expect(policy.parent).to eq parent
      expect(policy.options).to eq options
    end

    it "sets options when not specified parent" do
      options = { a: double }
      policy = SamplePolicy.new(user, nil, options)

      expect(policy.options).to eq options
    end
  end

  describe "defined instance methods" do
    let(:policy) { SamplePolicy.new(user) }

    it "defines index? method that returns true" do
      expect(policy.index?).to be true
    end

    it "defines show? method that returns true" do
      expect(policy.show?).to be true
    end

    it "defines create? method that returns false" do
      expect(policy.create?).to be false
    end

    it "defines update? method that returns false" do
      expect(policy.update?).to be false
    end

    it "defines destroy? method that returns false" do
      expect(policy.destroy?).to be false
    end

    it "defines new? method that calls create?" do
      expect(policy).to receive(:create?) { false }
      policy.new?
    end

    it "defines edit? method that calls create?" do
      expect(policy).to receive(:update?) { false }
      policy.edit?
    end
  end
end
