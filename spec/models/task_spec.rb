# spec/models/task_spec.rb
require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:project) { create(:project) }
  let(:task) { create(:task, project: project) }
  let(:user) { create(:user) }

  describe "associations" do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_many(:task_assignments).dependent(:destroy) }
    it { is_expected.to have_many(:assignees).through(:task_assignments) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:project_id) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:status).with_values(todo: 0, in_progress: 1, done: 2) }
  end

  describe "#assign_to" do
    it "creates a task assignment" do
      task.assign_to(user)
      expect(task.assignees).to include(user)
    end
  end

  describe "#move_to" do
    it "updates task status" do
      task.move_to(:in_progress)
      expect(task.status).to eq("in_progress")
    end
  end

  describe "#complete!" do
    it "marks task as done" do
      task.complete!
      expect(task.status).to eq("done")
      expect(task.completed_at).to be_present
    end
  end
end

# spec/models/project_spec.rb
require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project, owner: user) }

  describe "associations" do
    it { is_expected.to belong_to(:owner).class_name('User') }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
    it { is_expected.to have_many(:project_members).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:owner_id) }
  end

  describe "#add_member" do
    let(:member) { create(:user) }

    it "adds user to project members" do
      project.add_member(member)
      expect(project.members).to include(member)
    end

    it "does not duplicate members" do
      project.add_member(member)
      project.add_member(member)
      expect(project.members.where(id: member.id).count).to eq(1)
    end
  end

  describe "#archive!" do
    it "sets archived_at timestamp" do
      project.archive!
      expect(project.archived_at).to be_present
    end
  end
end

# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe "associations" do
    it { is_expected.to have_many(:projects).dependent(:nullify) }
    it { is_expected.to have_many(:task_assignments).dependent(:destroy) }
    it { is_expected.to have_many(:tasks).through(:task_assignments) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "#assigned_tasks" do
    let(:project) { create(:project, owner: user) }
    let(:task) { create(:task, project: project) }

    it "returns tasks assigned to user" do
      task.assign_to(user)
      expect(user.assigned_tasks).to include(task)
    end
  end
end
