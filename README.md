# Project Hub - Real-Time SaaS Collaboration Platform

A modern Trello/Slack hybrid for small teams to collaborate on tasks in real-time. Built with Rails 8, showcasing advanced features like WebSockets (ActionCable), real-time updates (Turbo Streams), drag-and-drop UI, and background job processing.

## ✨ Key Features

### Core Features
- **Projects**: Create and manage multiple projects
- **Tasks**: Organize work with To-Do, In Progress, and Done statuses
- **Task Assignment**: Assign tasks to team members
- **Real-time Collaboration**: See changes instantly across all users
- **Team Management**: Invite and collaborate with team members

### Resume "Wow" Factors
1. **ActionCable + Turbo Streams**: Real-time task updates without page refresh
   - When User A moves a task, User B sees it move instantly
   - Leverages WebSocket technology for instant two-way communication
   - Demonstrates mastery of Rails' streaming capabilities

2. **Drag & Drop UI**: Smooth, responsive task management
   - Implemented with Sortable.js
   - Instant status updates via AJAX
   - Professional UX similar to Trello

3. **Solid Queue Background Jobs**: 
   - Daily digest emails at 8:00 AM with task summaries
   - Task notification emails to assignees
   - Cron-job style scheduling built into Rails 8
   - Demonstrates production-grade background processing

## 🏗️ Architecture

### Database Models
```
User
  ├─ has_many :projects
  ├─ has_many :task_assignments
  └─ has_many :tasks (through task_assignments)

Project
  ├─ belongs_to :owner (User)
  ├─ has_many :tasks
  ├─ has_many :project_members
  └─ has_many :members (through project_members)

Task
  ├─ belongs_to :project
  ├─ has_many :task_assignments
  ├─ has_many :assignees (through task_assignments)
  └─ has_many :comments

TaskAssignment
  ├─ belongs_to :task
  └─ belongs_to :user

Comment
  ├─ belongs_to :task
  └─ belongs_to :author (User)
```

### Real-Time Features
- **ActionCable Channel**: `ProjectChannel` handles:
  - Task movements between columns
  - Task assignments to users
  - Real-time broadcasting to all connected clients

- **Turbo Streams**: 
  - Models use `broadcasts_to` for automatic updates
  - Task creation, updates, and deletions stream to all viewers
  - CRUD operations trigger turbo_stream responses

### Background Jobs
- **DigestEmailJob**: Sends daily task digests at 8:00 AM
- **TaskNotificationJob**: Notifies assignees of task updates
- **Solid Queue**: Built-in Rails 8 background processor

## 🚀 Setup & Installation

### Prerequisites
- Ruby 3.3+
- Rails 8
- PostgreSQL 12+
- Node.js 18+

### Installation

1. **Clone and Setup**
```bash
cd rubby
bundle install
yarn install  # or npm install
```

2. **Database Setup**
```bash
rails db:create
rails db:migrate
rails db:seed
```

3. **Start Development Server**
```bash
./bin/dev
```

This starts:
- Rails server on `localhost:3000`
- Asset bundler (Tailwind + esbuild)
- Solid Queue for background jobs

## 📊 Key Implementation Details

### Real-Time Task Updates
```ruby
# Models use Turbo Broadcasts
class Task < ApplicationRecord
  broadcasts_to -> { project }, inserts_by: :prepend
  broadcasts :update
end

# Tasks automatically appear in connected clients' browsers
```

### Drag-and-Drop Implementation
```erb
<script type="module">
  import { Sortable } from "sortablejs";
  new Sortable(taskColumn, {
    group: "tasks",
    onEnd(event) {
      fetch(`/tasks/${id}/move`, {
        method: "PATCH",
        body: JSON.stringify({ status: newStatus })
      });
    }
  });
</script>
```

### Background Job Scheduling
```ruby
# Solid Queue runs recurring jobs
Solid::Queue::ScheduledJob.new(
  DigestEmailJob,
  schedule: "every 1 day at 8:00 AM",
  timezone: "UTC"
).tap(&:schedule)
```

## 📦 Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Rails 8 |
| **Database** | PostgreSQL |
| **Real-time** | ActionCable + Turbo Streams |
| **Frontend** | Tailwind CSS, Stimulus JS |
| **Bundling** | esbuild, Tailwind CLI |
| **Background Jobs** | Solid Queue |
| **Authentication** | Devise |
| **Authorization** | Pundit |
| **Drag-and-Drop** | Sortable.js |
| **Email** | Action Mailer |

## 🎯 Project Features Showcase

### For Your Resume:
- ✅ Real-time WebSocket implementation
- ✅ Advanced Rails patterns (ActionCable, Turbo Streams)
- ✅ Background job processing with cron scheduling
- ✅ Database associations and scopes
- ✅ Authorization with Pundit
- ✅ Professional UI with Tailwind CSS
- ✅ RESTful API design
- ✅ Email automation
- ✅ Drag-and-drop UX

## 📝 File Structure

```
rubby/
├── app/
│   ├── channels/         # ActionCable channels
│   ├── controllers/      # Business logic
│   ├── jobs/            # Background jobs
│   ├── mailers/         # Email templates
│   ├── models/          # Data models
│   ├── policies/        # Authorization
│   └── views/           # Templates
├── config/
│   ├── cable.yml        # ActionCable config
│   └── initializers/    # Job scheduling
├── db/
│   ├── migrate/         # Database migrations
│   └── seeds.rb         # Sample data
└── Gemfile
```

## 🔄 Development Workflow

1. **Running Tests**
```bash
bundle exec rspec
```

2. **Code Quality**
```bash
bundle exec rubocop
```

3. **Database**
```bash
rails db:migrate
rails db:rollback
rails db:seed
```

4. **Background Jobs (Local)**
```bash
bundle exec solid_queue:start
```

## 🚢 Production Deployment

The application is ready for deployment to:
- Heroku (with SolidQueue buildpack)
- AWS/EC2
- DigitalOcean
- Any Dockerized environment

Environment variables needed:
```
DATABASE_URL=postgresql://...
REDIS_URL=redis://...
SMTP_ADDRESS=...
SMTP_PASSWORD=...
```

## 💡 Learning Outcomes

This project demonstrates:
- **Senior Rails Development**: ActionCable, Turbo, Hotwire patterns
- **Real-time Architecture**: WebSocket implementation and broadcasting
- **Background Processing**: Job scheduling with cron expressions
- **Database Design**: Complex associations and scopes
- **Authorization**: Pundit policies for multi-tenant access
- **Frontend Integration**: Modern JavaScript with Stimulus
- **Email Automation**: Async email delivery at scale
- **DevOps**: Docker, environment configuration

## 📚 Resources

- [Rails Guides - ActionCable](https://guides.rubyonrails.org/action_cable_overview.html)
- [Turbo Handbook](https://turbo.hotwired.dev/)
- [Hotwire Setup](https://hotwired.dev/)
- [Solid Queue Docs](https://github.com/rails/solid_queue)
- [Devise Documentation](https://github.com/heartcombo/devise)

---

**Built with ❤️ for the modern Rails developer**
