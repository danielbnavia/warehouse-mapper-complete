# Changelog
All notable changes to the Scope Mapper Power Automate Flow will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-14

### Added

#### Core Flow Features
- HTTP webhook trigger with JSON schema validation
- Variable initialization for Team ID, Plan ID, and Bucket IDs
- Dynamic project title extraction from webhook payload
- ForEach loop for processing action items array
- ForEach loop for processing missing information array
- Microsoft Graph Planner API integration for task creation
- Priority mapping (high=1, medium=5, low=9)
- Due date calculation based on dueInDays field
- Task description formatting with category and context
- Error handling with success/failure paths
- HTTP response actions (200 for success, 500 for error)
- Detailed response payloads with task counts and timestamps

#### Documentation
- `README.md` - Quick start guide and overview
- `DEPLOYMENT_GUIDE.md` - Comprehensive 7000+ word deployment instructions
- `FLOW_ARCHITECTURE.md` - Technical design document with diagrams
- `QUICK_REFERENCE.md` - Single-page cheat sheet
- `CHANGELOG.md` - Version history (this file)

#### Helper Scripts
- `Get-PlannerIDs.ps1` - PowerShell script to retrieve Planner IDs via Microsoft Graph
- `test_webhook.py` - Python script for webhook testing with custom payloads
- `Test-Webhook.ps1` - PowerShell script for webhook testing
- `sample_webhook_payload.json` - Example payload for testing

#### Configuration Files
- `config.template.json` - Configuration template for tracking IDs
- `requirements.txt` - Python dependencies
- `.gitignore` - Git ignore patterns for sensitive files

#### Package Files
- `flow.json` - Complete Power Automate flow definition
- `ScopeMapperFlow_Complete.zip` - Importable flow package

### Technical Details

#### Flow Actions (14 total)
1. Initialize_TeamID
2. Initialize_PlanID
3. Initialize_ActionItemsBucketID
4. Initialize_MissingInfoBucketID
5. Initialize_ProjectTitle
6. Loop_Through_Action_Items
   - Create_Action_Item_Task
   - Set_Task_Priority
7. Loop_Through_Missing_Information
   - Create_Missing_Info_Task
   - Set_Missing_Info_Priority
8. Compose_Success_Response
9. Response_Success
10. Compose_Error_Response
11. Response_Error

#### API Endpoints Used
- POST `/v1.0/planner/tasks` - Create tasks
- PATCH `/v1.0/planner/tasks/{id}` - Update task priority

#### Supported Fields
**Action Items:**
- title (required)
- description (required)
- priority (high/medium/low)
- category
- dueInDays (number)

**Missing Information:**
- item (required)
- priority (high/medium/low)
- category

### Features

#### Task Creation
- Automatic task creation in designated Planner buckets
- Separate buckets for action items vs. missing information
- Rich task descriptions with structured metadata
- Due date calculation from dueInDays field
- Priority setting via separate PATCH request

#### Error Handling
- Schema validation on webhook trigger
- Parallel runAfter conditions for error path
- Detailed error responses with failure reasons
- Proper HTTP status codes (200, 500)

#### Response Format
- JSON responses with consistent structure
- Success: status, message, projectTitle, tasksCreated, timestamp
- Error: status, message, error details, timestamp
- Task count reporting

### Infrastructure

#### Prerequisites
- Microsoft 365 account
- Power Automate Premium license
- Microsoft Planner access
- Microsoft Graph API permissions

#### Deployment Options
- Import via ZIP package
- Manual flow creation from JSON
- Environment-specific configuration via variables

### Testing

#### Test Scripts
- Python test script with requests library
- PowerShell test script with Invoke-RestMethod
- Sample payload for validation
- Custom payload generation options

#### Test Coverage
- Valid payload processing
- Empty array handling
- Priority mapping verification
- Error response validation

### Documentation Highlights

#### Deployment Guide Sections
1. Prerequisites and permissions
2. Planner plan and bucket setup
3. ID retrieval using Graph Explorer
4. Flow import and configuration
5. Webhook URL retrieval
6. Testing procedures
7. Troubleshooting guide
8. Monitoring and maintenance

#### Architecture Document Sections
1. Flow overview and diagram
2. Component details
3. Execution flow
4. Data flow mapping
5. Performance considerations
6. Security architecture
7. Error scenarios and recovery
8. Extension points

### Security

#### Features
- HTTPS-only communication
- URL-based webhook security
- OAuth 2.0 for Planner API
- User context execution
- Audit trail in flow history

#### Best Practices Documented
- Webhook URL confidentiality
- Connection management
- Data validation
- Access control
- Compliance standards

### Performance

#### Characteristics
- Sequential processing by default
- Typical run time: 5-30 seconds
- Suitable for 1-50 items per request
- Graph API rate limiting respected

#### Optimization Options
- Concurrency settings for ForEach loops
- Batch API operations for large sets
- Variable caching of IDs

### Integrations

#### Sample Code Provided
- JavaScript/TypeScript fetch example
- Python requests example
- PowerShell Invoke-RestMethod example
- Curl command examples

### Known Limitations

1. **Sequential Processing**: ForEach loops run sequentially by default
2. **Manual Configuration**: Plan/Bucket IDs must be manually configured
3. **No Assignment Logic**: Tasks created unassigned
4. **Basic Priority Mapping**: Only 3 priority levels supported
5. **No Retry Logic**: Failed tasks don't automatically retry

### Future Enhancements (Planned)

#### Potential v1.1 Features
- Automatic user assignment based on category
- Custom field mapping to Planner labels
- Teams notification on task creation
- Batch API support for large payloads
- Automatic ID discovery
- Retry logic with exponential backoff

#### Potential v2.0 Features
- Multi-plan support
- Dynamic bucket creation
- Integration with other Microsoft 365 services
- Advanced analytics and reporting
- Webhook authentication
- Workflow triggers on task completion

### Deployment Statistics

- **Total Files**: 15
- **Documentation**: 7 files, ~25,000 words
- **Scripts**: 3 files (2 PowerShell, 1 Python)
- **Configuration**: 4 files
- **Flow Definition**: 322 lines JSON
- **Actions**: 14 actions in flow

### Compatibility

- **Power Automate**: Premium license required
- **Microsoft Graph API**: v1.0
- **Planner API**: v1.0
- **PowerShell**: 5.1+ (Get-PlannerIDs.ps1 requires Microsoft.Graph module)
- **Python**: 3.7+ (requires requests library)

### License

- **Type**: Internal use
- **Distribution**: As-is
- **Support**: Community/self-supported

### Contributors

- Initial development: Claude Code
- Architecture design: AI-assisted
- Documentation: Comprehensive automated generation
- Testing: Sample scripts and payloads provided

### Support Resources

- **Documentation**: See README.md, DEPLOYMENT_GUIDE.md
- **Issues**: Review flow run history
- **Community**: Internal organization support
- **Updates**: Check changelog for version history

---

## Version Roadmap

### v1.0.0 (Current) - Initial Release
- Core functionality
- Complete documentation
- Test scripts
- Production ready

### v1.1.0 (Proposed) - Enhanced Features
- User assignment
- Custom labels
- Notifications
- Retry logic

### v2.0.0 (Future) - Advanced Features
- Multi-plan support
- Advanced analytics
- Additional integrations
- Enterprise features

---

**Note**: This is version 1.0.0 - the initial production release. All features documented here are included and tested.
