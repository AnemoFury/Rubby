# Project Hub - Complete Setup Guide

## Quick Start (5 minutes)

### 1. Prerequisites Check
```bash
ruby --version      # Should be 3.3.x
rails --version    # Should be 8.0+
node --version     # Should be 18+
postgres --version # Should be 12+
```

### 2. Install Dependencies
```bash
cd rubby
bundle install
yarn install
```

### 3. Database Setup
```bash
rails db:create
rails db:migrate
rails db:seed
```

### 4. Start Development
```bash
./bin/dev
```

Visit `http://localhost:3000` and login with:
- Email: `alice@example.com`
- Password: `password123`

---

## Full Setup (with Docker)

### Using Docker Compose
```bash
docker-compose up
```

Services will start on:
- Rails: `http://localhost:3000`
- PostgreSQL: `localhost:5432`
- Redis: `localhost:6379`

---

## Project Structure

```
rubby/
├── app/
│   ├── channels/         # WebSocket handlers (ActionCable)
│   │   └── project_channel.rb  # Real-time task updates
│   ├── controllers/      # Request handlers
│   │   ├── projects_controller.rb
│   │   └── tasks_controller.rb
│   ├── jobs/            # Background jobs
│   │   ├── digest_email_job.rb    # 8 AM digest emails
│   │   └── task_notification_job.rb
│   ├── models/          # Data models & associations
│   │   ├── user.rb
│   │   ├── project.rb
│   │   ├── task.rb
│   │   └── task_assignment.rb
│   ├── views/           # Templates (ERB + Turbo Streams)
│   │   ├── projects/
│   │   ├── tasks/
│   │   └── shared/
│   └── mailers/         # Email templates
│       ├── digest_mailer.rb
│       └── project_mailer.rb
├── config/
│   ├── routes.rb        # URL routing
│   ├── cable.yml        # ActionCable config
│   ├── environments/
│   │   ├── development.rb
│   │   └── production.rb
│   └── initializers/
│       ├── solid_queue.rb      # Job processing
│       └── recurring_jobs.rb   # Cron-like scheduling
├── db/
│   ├── migrate/         # Database schema
│   └── seeds.rb         # Sample data
└── docker-compose.yml   # Multi-container setup
```

---

## Key Features Walkthrough

### 1. Real-Time Collaboration (ActionCable + Turbo)

**How it works:**
1. User A opens a project and subscribes to `ProjectChannel`
2. User A moves a task to "Done"
3. The `move_task` action broadcasts to all connected clients
4. User B sees the task move instantly (no refresh)

**Files involved:**
- [app/channels/project_channel.rb](app/channels/project_channel.rb) - WebSocket logic
- [app/models/task.rb](app/models/task.rb) - Broadcasting setup with `broadcasts_to`

**Test it:**
```ruby
# Open two browser tabs to the same project
# Move a task in tab 1
# Watch it appear in tab 2 instantly
```

### 2. Drag-and-Drop Interface

**How it works:**
1. Tasks are rendered in three columns: To-Do, In Progress, Done
2. Sortable.js handles drag interactions
3. On drop, AJAX request moves task to new status
4. UI updates automatically via Turbo Streams

**Files involved:**
- [app/views/projects/show.html.erb](app/views/projects/show.html.erb) - Sortable setup
- [app/views/tasks/_task.html.erb](app/views/tasks/_task.html.erb) - Task card template

**Test it:**
```bash
# Navigate to a project
# Drag tasks between columns
# Tasks move instantly
```

### 3. Background Jobs & Email Digests

**How it works:**
1. Solid Queue runs `DigestEmailJob` daily at 8:00 AM (UTC)
2. Job queries all users for tasks updated in last 24 hours
3. Sends personalized digest emails with ActionMailer
4. No Redis needed—uses database for job queue

**Files involved:**
- [app/jobs/digest_email_job.rb](app/jobs/digest_email_job.rb) - Main job logic
- [config/initializers/recurring_jobs.rb](config/initializers/recurring_jobs.rb) - Cron schedule
- [app/views/digest_mailer/daily_digest.html.erb](app/views/digest_mailer/daily_digest.html.erb) - Email template

**Trigger manually (for testing):**
```ruby
# In Rails console
DigestEmailJob.perform_now
# or
DigestEmailJob.perform_later
```

---

## Development Workflow

### Running Tests
```bash
bundle exec rspec                    # All tests
bundle exec rspec spec/models       # Model tests
bundle exec rspec spec/controllers  # Controller tests
```

### Code Quality
```bash
bundle exec rubocop                 # Lint code
bundle exec rubocop -A             # Auto-fix issues
```

### Database Operations
```bash
rails db:migrate                    # Apply migrations
rails db:rollback                   # Undo last migration
rails db:seed                       # Load sample data
rails db:drop && rails db:create   # Fresh database
```

### Console Access
```bash
rails console                       # Interactive Ruby shell
# Example:
# > user = User.first
# > user.projects.count
# > task = Task.first
# > task.move_to(:done)
```

### Logs
```bash
tail -f log/development.log         # Follow logs
grep "ProjectChannel" log/development.log  # Filter by channel
```

---

## Production Deployment

### Environment Variables
Create `.env` file with:
```env
DATABASE_URL=postgresql://user:pass@db.example.com/prod
REDIS_URL=redis://redis.example.com:6379
SMTP_ADDRESS=smtp.sendgrid.net
SMTP_PASSWORD=SG.xxxxx
RAILS_HOST=yourdomain.com
ACTION_CABLE_URL=wss://yourdomain.com/cable
```

### Deploy to Heroku
```bash
# Create app
heroku create your-app-name

# Add PostgreSQL
heroku addons:create heroku-postgresql:standard-0

# Deploy code
git push heroku main

# Run migrations
heroku run rails db:migrate

# Seed data (optional)
heroku run rails db:seed

# Start worker dyno
heroku ps:scale worker=1

# Logs
heroku logs -t
```

### Deploy to Docker
```bash
docker build -t project-hub .
docker run -e DATABASE_URL=postgresql://... -p 3000:3000 project-hub
```

---

## Troubleshooting

### WebSocket Connection Issues
**Symptom:** Real-time updates not working

**Solution:**
```ruby
# Check cable.yml
config.action_cable.allowed_request_origins = [/http:\/\/localhost:*/]

# Restart server
# Kill ./bin/dev and restart
```

### Job Not Running
**Symptom:** Digest emails not sent at 8 AM

**Solution:**
```bash
# Check Solid Queue is running
ps aux | grep solid_queue

# If not, restart
./bin/dev

# Test manually
rails console
DigestEmailJob.perform_now
```

### Database Connection Error
**Symptom:** `could not connect to server`

**Solution:**
```bash
# Check PostgreSQL is running
brew services list | grep postgres

# Start it
brew services start postgresql

# Or with Docker
docker-compose up postgres
```

### Asset Compilation Error
**Solution:**
```bash
rails assets:clobber
rails assets:precompile
```

---

## Performance Tips

### Database
- Use `includes` for eager loading:
  ```ruby
  @projects = current_user.projects.includes(:tasks, :members)
  ```

### ActionCable
- Limit broadcast size: Don't broadcast entire projects, just the changed task
- Use specific channels: `ProjectChannel` not a global channel

### Background Jobs
- Use `perform_later` instead of `perform_now` in production
- Monitor queue: `rails solid_queue:status`

---

## Next Steps

### Enhance the App
- [ ] Add file attachments to tasks
- [ ] Implement task templates/cloning
- [ ] Add time tracking
- [ ] Create project analytics dashboard
- [ ] Build mobile app with React Native

### Advanced Features
- [ ] Real-time collaboration (like Google Docs)
- [ ] Activity feed with Turbo Streams
- [ ] Notification system (in-app + email)
- [ ] Webhook integrations (Slack, GitHub, etc.)
- [ ] Custom workflows & automation

### DevOps
- [ ] Setup GitHub Actions for CI/CD
- [ ] Container orchestration (Kubernetes)
- [ ] Monitoring (New Relic, Datadog)
- [ ] Load testing

---

## Resources

- [Rails Guides](https://guides.rubyonrails.org/)
- [ActionCable Documentation](https://guides.rubyonrails.org/action_cable_overview.html)
- [Turbo Handbook](https://turbo.hotwired.dev/)
- [Solid Queue GitHub](https://github.com/rails/solid_queue)
- [Devise Docs](https://github.com/heartcombo/devise)
- [Pundit Authorization](https://github.com/varvet/pundit)

---

## Support

For issues or questions:
1. Check the [README](README.md)
2. Review test files for examples
3. Check Rails logs: `tail -f log/development.log`
4. Run tests to verify setup: `bundle exec rspec`

Happy coding! 🚀
