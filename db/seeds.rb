# db/seeds.rb
# Create sample users
users = [
  User.create!(
    email: "alice@example.com",
    name: "Alice Johnson",
    password: "password123",
    password_confirmation: "password123"
  ),
  User.create!(
    email: "bob@example.com",
    name: "Bob Smith",
    password: "password123",
    password_confirmation: "password123"
  ),
  User.create!(
    email: "carol@example.com",
    name: "Carol White",
    password: "password123",
    password_confirmation: "password123"
  )
]

# Create sample projects
project1 = Project.create!(
  name: "Website Redesign",
  description: "Modernize the company website",
  owner: users[0]
)

project2 = Project.create!(
  name: "Mobile App",
  description: "Build iOS and Android apps",
  owner: users[1]
)

# Add members to projects
project1.add_member(users[1])
project1.add_member(users[2])

project2.add_member(users[0])
project2.add_member(users[2])

# Create sample tasks for project1
tasks_p1 = [
  Task.create!(
    title: "Create wireframes",
    description: "Design low-fidelity wireframes for key pages",
    project: project1,
    status: :todo,
    priority: "High"
  ),
  Task.create!(
    title: "Setup design system",
    description: "Create reusable components in Figma",
    project: project1,
    status: :in_progress,
    priority: "High"
  ),
  Task.create!(
    title: "Implement hero section",
    description: "Build responsive hero section with animations",
    project: project1,
    status: :done,
    priority: "Medium"
  )
]

# Create sample tasks for project2
tasks_p2 = [
  Task.create!(
    title: "Setup CI/CD pipeline",
    description: "Configure GitHub Actions for automated testing",
    project: project2,
    status: :todo,
    priority: "High"
  ),
  Task.create!(
    title: "Implement authentication",
    description: "Add OAuth2 with Google and GitHub",
    project: project2,
    status: :in_progress,
    priority: "High"
  ),
  Task.create!(
    title: "Database optimization",
    description: "Add indexes and optimize queries",
    project: project2,
    status: :todo,
    priority: "Medium"
  )
]

# Assign tasks to users
tasks_p1[0].assign_to(users[1])
tasks_p1[1].assign_to(users[2])
tasks_p1[2].assign_to(users[0])

tasks_p2[0].assign_to(users[0])
tasks_p2[1].assign_to(users[1])
tasks_p2[2].assign_to(users[2])

# Create sample comments
Comment.create!(
  body: "Let's prioritize the mobile view for the hero section",
  task: tasks_p1[2],
  author: users[0]
)

Comment.create!(
  body: "I'll implement the animations once we finalize the design",
  task: tasks_p1[2],
  author: users[1]
)

puts "✅ Seeded #{User.count} users"
puts "✅ Seeded #{Project.count} projects"
puts "✅ Seeded #{Task.count} tasks"
puts "✅ Seeded #{TaskAssignment.count} task assignments"
puts "✅ Seeded #{Comment.count} comments"
