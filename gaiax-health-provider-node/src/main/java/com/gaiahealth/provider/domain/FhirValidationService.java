package com.gaiahealth.provider.domain;

import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@Service
public class FhirValidationService {

    public void validateBundle(ClinicalCase clinicalCase, JsonNode payload) {
        validatePayload(clinicalCase, payload);
    }

    public void validatePayload(ClinicalCase clinicalCase, JsonNode payload) {
        List<ValidationIssue> issues = new ArrayList<>();

        if (payload == null || payload.isMissingNode()) {
            throw new ProviderApiException(
                    ProviderErrorCode.FHIR_VALIDATION_ERROR,
                    "payload is required",
                    List.of(new ValidationIssue("payload", "required"))
            );
        }

        String resourceType = payload.path("resourceType").asText();
        if ("Observation".equals(resourceType)) {
            validateObservationResource(clinicalCase, payload, "payload", true, issues);
        } else if ("Bundle".equals(resourceType)) {
            if (!"collection".equals(payload.path("type").asText())) {
                issues.add(new ValidationIssue("payload.type", "must be collection"));
            }

            JsonNode entries = payload.path("entry");
            if (!entries.isArray() || entries.isEmpty()) {
                issues.add(new ValidationIssue("payload.entry", "must contain at least one item"));
            }

            int validObservationCount = 0;
            if (entries.isArray()) {
                Iterator<JsonNode> iterator = entries.elements();
                int index = 0;
                while (iterator.hasNext()) {
                    JsonNode resource = iterator.next().path("resource");
                    if ("Observation".equals(resource.path("resourceType").asText())) {
                        List<ValidationIssue> observationIssues = new ArrayList<>();
                        validateObservationResource(clinicalCase, resource, "payload.entry[" + index + "].resource", false, observationIssues);
                        if (observationIssues.isEmpty()) {
                            validObservationCount++;
                        } else {
                            issues.addAll(observationIssues);
                        }
                    }
                    index++;
                }
            }

            if (validObservationCount == 0) {
                String clinicalCaseLabel = clinicalCase == null ? "unspecified" : clinicalCase.value();
                issues.add(new ValidationIssue(
                        "payload.entry",
                        "must contain at least one valid Observation for clinicalCase=" + clinicalCaseLabel
                ));
            }
        } else {
            issues.add(new ValidationIssue("payload.resourceType", "must be Bundle or Observation"));
        }

        if (!issues.isEmpty()) {
            throw new ProviderApiException(ProviderErrorCode.FHIR_VALIDATION_ERROR, "FHIR payload invalid", issues);
        }
    }

    private void validateObservationResource(
            ClinicalCase clinicalCase,
            JsonNode observation,
            String path,
            boolean strictSovereigntyMetadata,
            List<ValidationIssue> issues
    ) {
        if (!"Observation".equals(observation.path("resourceType").asText())) {
            issues.add(new ValidationIssue(path + ".resourceType", "must be Observation"));
        }
        requireText(observation, "status", path + ".status", issues);

        JsonNode coding0 = observation.path("code").path("coding").path(0);
        requireText(coding0, "system", path + ".code.coding[0].system", issues);
        requireText(coding0, "code", path + ".code.coding[0].code", issues);

        requireText(observation.path("subject"), "reference", path + ".subject.reference", issues);

        String effectiveDateTime = observation.path("effectiveDateTime").asText();
        if (effectiveDateTime.isBlank() || !isIsoDateTime(effectiveDateTime)) {
            issues.add(new ValidationIssue(path + ".effectiveDateTime", "must be valid ISO-8601 datetime"));
        }

        if ("Observation".equals(observation.path("resourceType").asText())) {
            if (clinicalCase != null) {
                switch (clinicalCase) {
                    case BLOOD_PRESSURE -> validateBloodPressure(observation, path, issues);
                    case HEART_RATE -> validateHeartRate(observation, path, issues);
                }
            }
            if (strictSovereigntyMetadata) {
                validateObservationProvenance(observation, path, issues);
            }
        }
    }

    private void validateObservationProvenance(JsonNode observation, String path, List<ValidationIssue> issues) {
        JsonNode meta = observation.path("meta");
        JsonNode profiles = meta.path("profile");
        if (!profiles.isArray() || profiles.isEmpty()) {
            issues.add(new ValidationIssue(path + ".meta.profile", "must contain the vitalsigns profile"));
        } else {
            boolean hasVitalSignsProfile = false;
            for (JsonNode profile : profiles) {
                if ("http://hl7.org/fhir/StructureDefinition/vitalsigns".equals(profile.asText())) {
                    hasVitalSignsProfile = true;
                    break;
                }
            }
            if (!hasVitalSignsProfile) {
                issues.add(new ValidationIssue(path + ".meta.profile", "must include http://hl7.org/fhir/StructureDefinition/vitalsigns"));
            }
        }

        JsonNode tags = meta.path("tag");
        if (!tags.isArray() || tags.isEmpty()) {
            issues.add(new ValidationIssue(path + ".meta.tag", "must contain sovereignty tags"));
        } else {
            boolean hasSovereigntyTag = false;
            for (JsonNode tag : tags) {
                String system = tag.path("system").asText();
                String code = tag.path("code").asText();
                String display = tag.path("display").asText();
                if ("https://gaia-x.eu/trust-framework#".equals(system)
                        && "sovereignty-policy".equals(code)
                        && !display.isBlank()) {
                    hasSovereigntyTag = true;
                    break;
                }
            }
            if (!hasSovereigntyTag) {
                issues.add(new ValidationIssue(path + ".meta.tag", "must include Gaia-X sovereignty policy tag"));
            }
        }

        requireText(observation.path("category").path(0).path("coding").path(0), "system", path + ".category[0].coding[0].system", issues);
        requireText(observation.path("category").path(0).path("coding").path(0), "code", path + ".category[0].coding[0].code", issues);
        requireText(observation.path("category").path(0).path("coding").path(0), "display", path + ".category[0].coding[0].display", issues);

        requireText(observation.path("code"), "text", path + ".code.text", issues);
        requireText(observation.path("subject"), "display", path + ".subject.display", issues);
        requireText(observation, "issued", path + ".issued", issues);

        JsonNode performer = observation.path("performer");
        if (!performer.isArray() || performer.isEmpty()) {
            issues.add(new ValidationIssue(path + ".performer", "required"));
        } else {
            requireText(performer.path(0), "reference", path + ".performer[0].reference", issues);
            requireText(performer.path(0), "display", path + ".performer[0].display", issues);
        }

        requireText(observation.path("bodySite").path("coding").path(0), "system", path + ".bodySite.coding[0].system", issues);
        requireText(observation.path("bodySite").path("coding").path(0), "code", path + ".bodySite.coding[0].code", issues);
        requireText(observation.path("bodySite").path("coding").path(0), "display", path + ".bodySite.coding[0].display", issues);

        requireText(observation.path("device"), "reference", path + ".device.reference", issues);
        JsonNode identifiers = observation.path("device").path("identifier");
        if (!identifiers.isArray() || identifiers.isEmpty()) {
            issues.add(new ValidationIssue(path + ".device.identifier", "required"));
        } else {
            requireText(identifiers.path(0), "system", path + ".device.identifier[0].system", issues);
            requireText(identifiers.path(0), "value", path + ".device.identifier[0].value", issues);
        }

        requireText(observation.path("encounter"), "reference", path + ".encounter.reference", issues);
    }

    private void validateBloodPressure(JsonNode observation, String path, List<ValidationIssue> issues) {
        String code = observation.path("code").path("coding").path(0).path("code").asText();
        if (!"85354-9".equals(code)) {
            issues.add(new ValidationIssue(path + ".code.coding[0].code", "must be 85354-9 for blood-pressure"));
        }

        JsonNode components = observation.path("component");
        if (!components.isArray() || components.isEmpty()) {
            issues.add(new ValidationIssue(path + ".component", "must contain systolic and diastolic components"));
            return;
        }

        boolean hasSystolic = false;
        boolean hasDiastolic = false;

        for (JsonNode component : components) {
            String componentCode = component.path("code").path("coding").path(0).path("code").asText();
            JsonNode value = component.path("valueQuantity").path("value");

            if ("8480-6".equals(componentCode) && value.isNumber()) {
                hasSystolic = true;
            }
            if ("8462-4".equals(componentCode) && value.isNumber()) {
                hasDiastolic = true;
            }
        }

        if (!hasSystolic) {
            issues.add(new ValidationIssue(path + ".component", "missing systolic component 8480-6 with numeric value"));
        }
        if (!hasDiastolic) {
            issues.add(new ValidationIssue(path + ".component", "missing diastolic component 8462-4 with numeric value"));
        }
    }

    private void validateHeartRate(JsonNode observation, String path, List<ValidationIssue> issues) {
        String code = observation.path("code").path("coding").path(0).path("code").asText();
        if (!"8867-4".equals(code)) {
            issues.add(new ValidationIssue(path + ".code.coding[0].code", "must be 8867-4 for heart-rate"));
        }

        JsonNode value = observation.path("valueQuantity").path("value");
        if (!value.isNumber()) {
            issues.add(new ValidationIssue(path + ".valueQuantity.value", "must be numeric"));
        }
    }

    private void requireText(JsonNode node, String field, String path, List<ValidationIssue> issues) {
        String value = node.path(field).asText();
        if (value == null || value.isBlank()) {
            issues.add(new ValidationIssue(path, "required"));
        }
    }

    private boolean isIsoDateTime(String raw) {
        try {
            Instant.parse(raw);
            return true;
        } catch (DateTimeParseException ex) {
            try {
                OffsetDateTime.parse(raw);
                return true;
            } catch (DateTimeParseException ignored) {
                return false;
            }
        }
    }
}
