# 🆔 Onfido Identity Verification Implementation Plan

Complete implementation guide for integrating Onfido identity verification in ForeverUsInLove Flutter app.

---

## 📋 Table of Contents

1. [Current Screen Analysis](#current-screen-analysis)
2. [Onfido Overview](#onfido-overview)
3. [Complete Flow](#complete-flow)
4. [Backend Integration](#backend-integration)
5. [Flutter SDK Integration](#flutter-sdk-integration)
6. [UI Implementation](#ui-implementation)
7. [Testing Strategy](#testing-strategy)
8. [Security Considerations](#security-considerations)

---

## 🎨 Current Screen Analysis

### Verification Introduction Screen

**Content:**
- **Title:** "Why Verification Matters"
- **Description:** "To make ForeverUs In Love a real, trustworthy community, every member completes a secure identity check."

**Benefits Listed:**
- ✅ Protection from fake profiles
- ✅ Safer and more respectful interactions
- ✅ A verified, trustworthy community

**Fee Information:**
- **Amount:** $1.99 USD one-time fee
- **Purpose:** "Helps us keep our community safe using advanced biometric technology and human moderation"

**Privacy Notice:**
- "Your privacy is protected — your data is encrypted and never shared"

**Actions:**
- **Primary:** "Proceed to pay verification" (Green button)
- **Secondary:** "Skip" (Top right)

### UI Design Notes
- Clean, minimal design with ample white space
- Green color for trust/safety actions
- Gray for neutral information
- Check icons for benefits
- Exclamation mark icon for privacy notice

---

## 🔍 Onfido Overview

### What is Onfido?
Onfido (now Entrust Identity Verification) is an AI-powered identity verification platform that provides:
- Document verification (passport, ID card, driver's license)
- Facial biometric verification
- Liveness detection
- NFC chip reading
- Advanced fraud detection

### Current Status (October 2025)
- **Latest Flutter SDK:** Available on pub.dev (onfido_sdk)
- **Dart Version:** 3.1.0+
- **Flutter Version:** 1.20+
- **iOS Support:** 13+
- **Android Support:** API 21+
- **License:** MIT

### Key Features
1. **Smart Capture SDK** - Pre-built UI for document and face capture
2. **Studio Workflows** - Visual workflow builder for verification flows
3. **NFC Support** - Enabled by default for supported documents
4. **40+ Languages** - Built-in localization
5. **Dark Mode** - Supported from v4.1.0
6. **Customization** - Colors, fonts, co-branding

---

## 🔄 Complete Flow

### User Journey

```
1. About You Form (Current)
   ↓
2. Location/Address (Current)
   ↓
3. Verification Introduction Screen ← We are here
   ↓
4. Payment Processing ($1.99)
   ↓
5. Onfido SDK Launch
   │
   ├─→ Document Capture
   │   ├─ Document Type Selection
   │   ├─ Front Side Capture
   │   ├─ Back Side Capture (if needed)
   │   └─ NFC Reading (if supported)
   │
   ├─→ Face Capture
   │   ├─ Intro Screen
   │   ├─ Selfie/Video/Motion Capture
   │   └─ Liveness Check
   │
   └─→ Upload & Processing
       ↓
6. Processing Screen (Our Custom UI)
   ↓
7. Result Screen
   │
   ├─→ Success → Home Screen
   └─→ Needs Review → Pending Status
```

### Technical Flow

```
Backend Flow:
1. User clicks "Proceed to pay verification"
2. Process payment ($1.99)
3. Create Onfido Applicant (POST /applicants)
4. Create Workflow Run (POST /workflow_runs)
   → Returns: workflow_run_id + sdk_token
5. Return sdk_token to Flutter app

Flutter Flow:
6. Initialize Onfido SDK with sdk_token
7. Launch Onfido.startWorkflow(workflowRunId)
8. Onfido SDK captures documents & face
9. Onfido uploads directly to their servers
10. SDK returns completion callback
11. Show processing screen

Backend Webhook:
12. Onfido sends webhook on completion
13. Fetch results (GET /workflow_runs/{id})
14. Update user verification status in database
15. Notify user via push notification

Flutter Polling (alternative):
12. Poll backend for verification status
13. Update UI based on status
```

---

## 🔧 Backend Integration

### Required API Endpoints

#### 1. Create Verification Session
```dart
POST /api/v1/verification/create
Authorization: Bearer {user_token}

Request:
{
  "payment_transaction_id": "txn_123456"
}

Response:
{
  "applicant_id": "abc-123",
  "workflow_run_id": "wfr-456",
  "sdk_token": "sdk_token_xyz",
  "expires_at": "2025-11-04T10:00:00Z"
}
```

#### 2. Get Verification Status
```dart
GET /api/v1/verification/status
Authorization: Bearer {user_token}

Response:
{
  "status": "awaiting_input|processing|approved|review|declined",
  "created_at": "2025-10-28T10:00:00Z",
  "completed_at": "2025-10-28T10:05:00Z",
  "result": {
    "document_verified": true,
    "face_verified": true,
    "overall": "clear|consider"
  }
}
```

#### 3. Webhook Receiver
```dart
POST /api/v1/webhooks/onfido
X-SHA2-Signature: {signature}

Body:
{
  "payload": {
    "resource_type": "workflow_run",
    "action": "workflow_run.completed",
    "object": {
      "id": "wfr-456",
      "status": "approved",
      "output": { ... }
    }
  }
}
```

### Backend Implementation (Laravel)

#### Models

```php
// app/Models/VerificationSession.php
class VerificationSession extends Model
{
    protected $fillable = [
        'user_id',
        'onfido_applicant_id',
        'onfido_workflow_run_id',
        'status', // pending, processing, approved, review, declined
        'payment_transaction_id',
        'sdk_token_expires_at',
        'result_data',
        'completed_at',
    ];

    protected $casts = [
        'result_data' => 'array',
        'sdk_token_expires_at' => 'datetime',
        'completed_at' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
```

#### Service

```php
// app/Services/OnfidoService.php
class OnfidoService
{
    private $client;
    private $apiToken;
    private $baseUrl;

    public function __construct()
    {
        $this->apiToken = config('onfido.api_token');
        $this->baseUrl = config('onfido.base_url'); // https://api.eu.onfido.com/v3.6
        
        $this->client = new \GuzzleHttp\Client([
            'base_uri' => $this->baseUrl,
            'headers' => [
                'Authorization' => 'Token token=' . $this->apiToken,
                'Content-Type' => 'application/json',
            ],
        ]);
    }

    public function createApplicant(User $user)
    {
        $response = $this->client->post('/applicants', [
            'json' => [
                'first_name' => $user->first_name,
                'last_name' => $user->last_name,
                'dob' => $user->date_of_birth,
                'address' => [
                    'street' => $user->address_street,
                    'town' => $user->address_city,
                    'postcode' => $user->address_postal_code,
                    'country' => $user->address_country_code,
                ],
            ],
        ]);

        return json_decode($response->getBody(), true);
    }

    public function createWorkflowRun(string $applicantId, string $workflowId)
    {
        $response = $this->client->post('/workflow_runs', [
            'json' => [
                'workflow_id' => $workflowId,
                'applicant_id' => $applicantId,
            ],
        ]);

        return json_decode($response->getBody(), true);
    }

    public function getWorkflowRun(string $workflowRunId)
    {
        $response = $this->client->get("/workflow_runs/{$workflowRunId}");
        return json_decode($response->getBody(), true);
    }

    public function verifyWebhookSignature(string $signature, string $body)
    {
        $secret = config('onfido.webhook_secret');
        $expectedSignature = hash_hmac('sha256', $body, $secret);
        return hash_equals($expectedSignature, $signature);
    }
}
```

#### Controller

```php
// app/Http/Controllers/Api/VerificationController.php
class VerificationController extends Controller
{
    private $onfidoService;

    public function __construct(OnfidoService $onfidoService)
    {
        $this->onfidoService = $onfidoService;
    }

    public function create(Request $request)
    {
        $request->validate([
            'payment_transaction_id' => 'required|string',
        ]);

        $user = $request->user();

        // Verify payment was successful
        $payment = Payment::where('transaction_id', $request->payment_transaction_id)
            ->where('user_id', $user->id)
            ->where('status', 'completed')
            ->first();

        if (!$payment) {
            return response()->json(['error' => 'Payment not found or incomplete'], 400);
        }

        // Check if user already has a verification session
        $existingSession = VerificationSession::where('user_id', $user->id)
            ->whereIn('status', ['approved', 'processing'])
            ->first();

        if ($existingSession) {
            return response()->json(['error' => 'Verification already in progress'], 400);
        }

        // Create Onfido applicant
        $applicant = $this->onfidoService->createApplicant($user);

        // Create workflow run
        $workflowId = config('onfido.workflow_id');
        $workflowRun = $this->onfidoService->createWorkflowRun(
            $applicant['id'],
            $workflowId
        );

        // Save session
        $session = VerificationSession::create([
            'user_id' => $user->id,
            'onfido_applicant_id' => $applicant['id'],
            'onfido_workflow_run_id' => $workflowRun['id'],
            'status' => 'pending',
            'payment_transaction_id' => $request->payment_transaction_id,
            'sdk_token_expires_at' => now()->addWeeks(5),
        ]);

        return response()->json([
            'applicant_id' => $applicant['id'],
            'workflow_run_id' => $workflowRun['id'],
            'sdk_token' => $workflowRun['sdk_token'],
            'expires_at' => $session->sdk_token_expires_at,
        ]);
    }

    public function status(Request $request)
    {
        $user = $request->user();
        
        $session = VerificationSession::where('user_id', $user->id)
            ->latest()
            ->first();

        if (!$session) {
            return response()->json(['error' => 'No verification session found'], 404);
        }

        return response()->json([
            'status' => $session->status,
            'created_at' => $session->created_at,
            'completed_at' => $session->completed_at,
            'result' => $session->result_data,
        ]);
    }
}
```

#### Webhook Handler

```php
// app/Http/Controllers/Api/WebhookController.php
class WebhookController extends Controller
{
    private $onfidoService;

    public function __construct(OnfidoService $onfidoService)
    {
        $this->onfidoService = $onfidoService;
    }

    public function onfido(Request $request)
    {
        // Verify webhook signature
        $signature = $request->header('X-SHA2-Signature');
        $body = $request->getContent();

        if (!$this->onfidoService->verifyWebhookSignature($signature, $body)) {
            return response()->json(['error' => 'Invalid signature'], 401);
        }

        $payload = $request->json('payload');
        
        if ($payload['resource_type'] !== 'workflow_run') {
            return response()->json(['status' => 'ignored']);
        }

        $workflowRunId = $payload['object']['id'];
        $action = $payload['action'];

        // Find verification session
        $session = VerificationSession::where('onfido_workflow_run_id', $workflowRunId)
            ->first();

        if (!$session) {
            Log::warning("Webhook received for unknown workflow run: {$workflowRunId}");
            return response()->json(['status' => 'ignored']);
        }

        // Update session based on action
        if ($action === 'workflow_run.completed') {
            // Fetch full results
            $workflowRun = $this->onfidoService->getWorkflowRun($workflowRunId);
            
            $session->update([
                'status' => $workflowRun['status'], // approved, review, declined
                'result_data' => $workflowRun['output'],
                'completed_at' => now(),
            ]);

            // Update user verification status
            if ($workflowRun['status'] === 'approved') {
                $session->user->update(['is_verified' => true]);
                
                // Send push notification
                Notification::send($session->user, new VerificationApprovedNotification());
            }
        }

        return response()->json(['status' => 'processed']);
    }
}
```

#### Configuration

```php
// config/onfido.php
return [
    'api_token' => env('ONFIDO_API_TOKEN'),
    'base_url' => env('ONFIDO_BASE_URL', 'https://api.eu.onfido.com/v3.6'),
    'workflow_id' => env('ONFIDO_WORKFLOW_ID'),
    'webhook_secret' => env('ONFIDO_WEBHOOK_SECRET'),
];
```

#### Environment Variables

```env
# .env
ONFIDO_API_TOKEN=api_sandbox.xxxxxxxxxxxxxxx
ONFIDO_BASE_URL=https://api.eu.onfido.com/v3.6
ONFIDO_WORKFLOW_ID=your-workflow-id
ONFIDO_WEBHOOK_SECRET=your-webhook-secret
```

---

## 📱 Flutter SDK Integration

### 1. Add Dependency

```yaml
# pubspec.yaml
dependencies:
  onfido_sdk: ^latest_version

dev_dependencies:
  # Test dependencies...
```

### 2. iOS Configuration

```ruby
# ios/Podfile
platform :ios, '13.0'
```

```xml
<!-- ios/Runner/Info.plist -->
<key>NSCameraUsageDescription</key>
<string>Required for document and facial capture during identity verification</string>

<key>NSMicrophoneUsageDescription</key>
<string>Required for video capture during identity verification</string>
```

### 3. Android Configuration

```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### 4. Create Verification Service

```dart
// lib/features/verification/data/services/onfido_verification_service.dart
import 'package:onfido_sdk/onfido_sdk.dart';
import 'package:flutter/services.dart';

class OnfidoVerificationService {
  Future<OnfidoVerificationResult> startVerification({
    required String sdkToken,
    required String workflowRunId,
  }) async {
    try {
      // Initialize Onfido SDK
      final onfido = Onfido(
        sdkToken: sdkToken,
        onfidoTheme: OnfidoTheme.AUTOMATIC,
        nfcOption: NFCOptions.OPTIONAL, // Enable NFC for passports
      );

      // Start workflow
      await onfido.startWorkflow(workflowRunId);

      // If we reach here, verification completed successfully
      return OnfidoVerificationResult(
        status: VerificationStatus.completed,
        workflowRunId: workflowRunId,
      );
    } on PlatformException catch (e) {
      // Handle errors
      return _handleError(e);
    }
  }

  OnfidoVerificationResult _handleError(PlatformException error) {
    switch (error.code) {
      case 'exit':
        return OnfidoVerificationResult(
          status: VerificationStatus.cancelled,
          errorMessage: 'User cancelled the verification',
        );
      case 'cameraPermission':
        return OnfidoVerificationResult(
          status: VerificationStatus.error,
          errorMessage: 'Camera permission is required',
        );
      case 'microphonePermission':
        return OnfidoVerificationResult(
          status: VerificationStatus.error,
          errorMessage: 'Microphone permission is required',
        );
      case 'error':
        return OnfidoVerificationResult(
          status: VerificationStatus.error,
          errorMessage: error.message ?? 'An error occurred',
        );
      default:
        return OnfidoVerificationResult(
          status: VerificationStatus.error,
          errorMessage: 'Unexpected error: ${error.code}',
        );
    }
  }
}

// Models
enum VerificationStatus {
  completed,
  cancelled,
  error,
}

class OnfidoVerificationResult {
  final VerificationStatus status;
  final String? workflowRunId;
  final String? errorMessage;

  OnfidoVerificationResult({
    required this.status,
    this->workflowRunId,
    this->errorMessage,
  });
}
```

### 5. Create Repository

```dart
// lib/features/verification/data/repositories/verification_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/auth_api_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/repositories/verification_repository.dart';
import '../services/onfido_verification_service.dart';

class VerificationRepositoryImpl implements VerificationRepository {
  final AuthApiClient apiClient;
  final OnfidoVerificationService onfidoService;
  final SecureStorageService storageService;

  VerificationRepositoryImpl({
    required this.apiClient,
    required this.onfidoService,
    required this.storageService,
  });

  @override
  Future<Either<Failure, VerificationSession>> createVerificationSession({
    required String paymentTransactionId,
  }) async {
    try {
      final response = await apiClient.createVerificationSession(
        {'payment_transaction_id': paymentTransactionId},
      );
      
      return Right(VerificationSession.fromJson(response));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OnfidoVerificationResult>> startVerification({
    required String sdkToken,
    required String workflowRunId,
  }) async {
    try {
      final result = await onfidoService.startVerification(
        sdkToken: sdkToken,
        workflowRunId: workflowRunId,
      );
      
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VerificationStatusResponse>> getVerificationStatus() async {
    try {
      final response = await apiClient.getVerificationStatus();
      return Right(VerificationStatusResponse.fromJson(response));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

### 6. Create Models

```dart
// lib/features/verification/data/models/verification_session.dart
import 'package:json_annotation/json_annotation.dart';

part 'verification_session.g.dart';

@JsonSerializable()
class VerificationSession {
  @JsonKey(name: 'applicant_id')
  final String applicantId;
  
  @JsonKey(name: 'workflow_run_id')
  final String workflowRunId;
  
  @JsonKey(name: 'sdk_token')
  final String sdkToken;
  
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;

  VerificationSession({
    required this.applicantId,
    required this.workflowRunId,
    required this.sdkToken,
    required this.expiresAt,
  });

  factory VerificationSession.fromJson(Map<String, dynamic> json) =>
      _$VerificationSessionFromJson(json);
  
  Map<String, dynamic> toJson() => _$VerificationSessionToJson(this);
}

@JsonSerializable()
class VerificationStatusResponse {
  final String status;
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  
  final Map<String, dynamic>? result;

  VerificationStatusResponse({
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.result,
  });

  factory VerificationStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$VerificationStatusResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$VerificationStatusResponseToJson(this);
}
```

---

## 🎨 UI Implementation

### 1. Verification Introduction Page (Current Screen)

```dart
// lib/features/verification/presentation/pages/verification_intro_page.dart
import 'package:flutter/material.dart';

class VerificationIntroPage extends StatelessWidget {
  const VerificationIntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Skip verification for now
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Title
              const Text(
                'Why Verification\nMatters',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Description
              const Text(
                'To make ForeverUs In Love a real, trustworthy community, every member completes a secure identity check.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Benefits
              const Text(
                'What this means for you',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              _buildBenefit('Protection from fake profiles'),
              const SizedBox(height: 12),
              _buildBenefit('Safer and more respectful interactions'),
              const SizedBox(height: 12),
              _buildBenefit('A verified, trustworthy community'),
              
              const SizedBox(height: 32),
              
              // Fee explanation
              const Text(
                'Why there\'s a small fee',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 12),
              
              const Text(
                'The 1.99 USD one-time verification fee helps us keep our community safe using advanced biometric technology and human moderation.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              
              const Spacer(),
              
              // Privacy notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Your privacy is protected — your data is encrypted and never shared.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Proceed button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to payment
                    Navigator.pushNamed(context, '/verification/payment');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF34C759),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Proceed to pay verification',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFD1F2DD),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Color(0xFF34C759),
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
```

### 2. Payment Page

```dart
// lib/features/verification/presentation/pages/verification_payment_page.dart
class VerificationPaymentPage extends StatefulWidget {
  const VerificationPaymentPage({Key? key}) : super(key: key);

  @override
  State<VerificationPaymentPage> createState() => _VerificationPaymentPageState();
}

class _VerificationPaymentPageState extends State<VerificationPaymentPage> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    try {
      // 1. Process payment with Stripe/PayPal
      final paymentResult = await PaymentService.processPayment(
        amount: 1.99,
        currency: 'USD',
        description: 'Identity Verification Fee',
      );

      if (paymentResult.success) {
        // 2. Create verification session
        final repository = GetIt.instance<VerificationRepository>();
        final sessionResult = await repository.createVerificationSession(
          paymentTransactionId: paymentResult.transactionId,
        );

        sessionResult.fold(
          (failure) {
            // Show error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.message)),
            );
            setState(() => _isProcessing = false);
          },
          (session) {
            // Navigate to Onfido SDK
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OnfidoVerificationPage(
                  sdkToken: session.sdkToken,
                  workflowRunId: session.workflowRunId,
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Payment UI implementation
    // Include Stripe/PayPal payment form
    return Scaffold(/* ... */);
  }
}
```

### 3. Onfido Verification Page

```dart
// lib/features/verification/presentation/pages/onfido_verification_page.dart
class OnfidoVerificationPage extends StatefulWidget {
  final String sdkToken;
  final String workflowRunId;

  const OnfidoVerificationPage({
    Key? key,
    required this.sdkToken,
    required this.workflowRunId,
  }) : super(key: key);

  @override
  State<OnfidoVerificationPage> createState() => _OnfidoVerificationPageState();
}

class _OnfidoVerificationPageState extends State<OnfidoVerificationPage> {
  @override
  void initState() {
    super.initState();
    _startVerification();
  }

  Future<void> _startVerification() async {
    final repository = GetIt.instance<VerificationRepository>();
    
    final result = await repository.startVerification(
      sdkToken: widget.sdkToken,
      workflowRunId: widget.workflowRunId,
    );

    result.fold(
      (failure) {
        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Verification Error'),
            content: Text(failure.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      (verificationResult) {
        switch (verificationResult.status) {
          case VerificationStatus.completed:
            // Navigate to processing screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const VerificationProcessingPage(),
              ),
            );
            break;
          case VerificationStatus.cancelled:
            // User cancelled - go back
            Navigator.pop(context);
            break;
          case VerificationStatus.error:
            // Show error
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(verificationResult.errorMessage ?? 'Unknown error'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while Onfido SDK is initializing
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
```

### 4. Processing Page

```dart
// lib/features/verification/presentation/pages/verification_processing_page.dart
class VerificationProcessingPage extends StatefulWidget {
  const VerificationProcessingPage({Key? key}) : super(key: key);

  @override
  State<VerificationProcessingPage> createState() => _VerificationProcessingPageState();
}

class _VerificationProcessingPageState extends State<VerificationProcessingPage> {
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    // Poll every 3 seconds
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final repository = GetIt.instance<VerificationRepository>();
      final result = await repository.getVerificationStatus();

      result.fold(
        (failure) {
          // Handle error
        },
        (status) {
          if (status.status == 'approved') {
            timer.cancel();
            Navigator.pushReplacementNamed(context, '/verification/success');
          } else if (status.status == 'declined') {
            timer.cancel();
            Navigator.pushReplacementNamed(context, '/verification/failed');
          } else if (status.status == 'review') {
            timer.cancel();
            Navigator.pushReplacementNamed(context, '/verification/review');
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 32),
              const Text(
                'Verifying your identity...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'This usually takes less than a minute. Please don\'t close the app.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🧪 Testing Strategy

### Unit Tests

```dart
// test/features/verification/data/services/onfido_verification_service_test.dart
void main() {
  late OnfidoVerificationService service;

  setUp(() {
    service = OnfidoVerificationService();
  });

  group('OnfidoVerificationService', () {
    test('should complete verification successfully', () async {
      // Test implementation
    });

    test('should handle user cancellation', () async {
      // Test implementation
    });

    test('should handle camera permission error', () async {
      // Test implementation
    });
  });
}
```

### Integration Tests

```dart
// integration_test/verification_flow_test.dart
void main() {
  testWidgets('Complete verification flow', (tester) async {
    // 1. Navigate to verification intro
    // 2. Tap proceed button
    // 3. Complete payment
    // 4. Verify Onfido SDK launches
    // 5. Complete verification
    // 6. Verify success screen shows
  });
}
```

### Manual Testing Checklist

- [ ] Verification intro page displays correctly
- [ ] Skip button works
- [ ] Payment processes successfully
- [ ] Onfido SDK launches with correct token
- [ ] Document capture works (front/back)
- [ ] Face capture works (selfie/video)
- [ ] NFC reading works (if supported)
- [ ] User can cancel mid-verification
- [ ] Processing screen shows while waiting
- [ ] Success screen shows on approval
- [ ] Review screen shows when needed
- [ ] Failed screen shows on decline
- [ ] Webhooks update status correctly
- [ ] Push notifications sent on completion

---

## 🔒 Security Considerations

### Best Practices

1. **Never expose API tokens on frontend**
   - Generate SDK tokens on backend
   - Return only SDK token to Flutter app

2. **Validate webhook signatures**
   - Use X-SHA2-Signature header
   - Verify with HMAC SHA256

3. **Secure token storage**
   - Don't store SDK tokens permanently
   - Clear after use

4. **Payment verification**
   - Verify payment before creating session
   - Link verification to payment transaction

5. **Rate limiting**
   - Limit verification attempts per user
   - Prevent abuse of verification system

6. **Data encryption**
   - All API calls over HTTPS
   - Encrypt sensitive data in database

7. **User privacy**
   - Inform users about data usage
   - Comply with GDPR/privacy laws
   - Allow users to request data deletion

---

## 📝 Implementation Checklist

### Backend

- [ ] Add Onfido configuration to .env
- [ ] Create VerificationSession model and migration
- [ ] Implement OnfidoService
- [ ] Create VerificationController endpoints
- [ ] Implement webhook handler
- [ ] Add routes to api.php
- [ ] Configure webhook URL in Onfido Dashboard
- [ ] Test with Postman collection
- [ ] Add verification status to User model

### Flutter

- [ ] Add onfido_sdk dependency
- [ ] Configure iOS Info.plist
- [ ] Configure Android permissions
- [ ] Create verification models
- [ ] Implement OnfidoVerificationService
- [ ] Create VerificationRepository
- [ ] Update DI configuration
- [ ] Create VerificationIntroPage
- [ ] Create VerificationPaymentPage
- [ ] Create OnfidoVerificationPage
- [ ] Create VerificationProcessingPage
- [ ] Create VerificationSuccessPage
- [ ] Update navigation routes
- [ ] Add tests
- [ ] Test on physical devices

### Documentation

- [ ] Update API documentation
- [ ] Add verification flow diagrams
- [ ] Document webhook payload structure
- [ ] Add troubleshooting guide
- [ ] Update user privacy policy

---

## 🎯 Next Steps

1. **Configure Onfido Account**
   - Create Onfido account
   - Create Studio workflow
   - Configure webhook URL
   - Get API credentials

2. **Implement Payment**
   - Choose payment provider (Stripe/PayPal)
   - Integrate payment SDK
   - Test payment flow

3. **Backend Implementation**
   - Follow backend implementation section
   - Test with Postman
   - Deploy to staging

4. **Flutter Implementation**
   - Follow Flutter SDK integration
   - Test on devices
   - Handle edge cases

5. **Testing**
   - End-to-end testing
   - Security audit
   - Performance testing

6. **Go Live**
   - Switch to live API token
   - Monitor webhooks
   - Monitor user feedback

---

**Estimated Implementation Time:** 2-3 weeks

**Key Dependencies:**
- Onfido account setup
- Payment integration
- Backend API ready
- Testing devices available

**Cost Considerations:**
- Onfido pricing per verification
- Payment processing fees ($1.99 charge)
- Hosting for webhook endpoint
