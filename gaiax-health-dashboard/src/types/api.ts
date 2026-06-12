import type { FhirObservation } from './fhir'

export interface ConsumptionJob {
  id: string
  patientId: string
  datasetId: string
  status: 'PENDING' | 'IN_PROGRESS' | 'SUCCEEDED' | 'FAILED'
  consumedAt: string
  measurements: FhirObservation[]
  metadata: {
    xRequestId: string
  }
  consumerId?: string
  consumerDid?: string
  receiverDid?: string
  purpose?: string
  consentStatus?: 'PENDING' | 'APPROVED' | 'REJECTED'
  decisionReason?: string
  validFrom?: string
  validTo?: string
}

export interface Dataset {
  datasetId: string
  name: string
  resourceType: string
  recordCount: number
  publishedAt?: string
}

export interface DatasetsResponse {
  items: Dataset[]
}

export interface AccessRequest {
  id: string
  patientId: string
  datasetId: string
  status: 'PENDING' | 'APPROVED' | 'REJECTED'
  createdAt: string
}

export interface ApiError {
  code: string
  message: string
  timestamp: string
  xRequestId?: string
}
