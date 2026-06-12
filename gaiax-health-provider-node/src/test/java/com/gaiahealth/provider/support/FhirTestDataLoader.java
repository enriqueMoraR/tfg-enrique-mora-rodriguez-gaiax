package com.gaiahealth.provider.support;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.io.InputStream;
import java.io.UncheckedIOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public final class FhirTestDataLoader {
    public static final String PAYLOAD_BUNDLE_SAMPLE = "/fhir/payloads/bundle-sample.json";
    public static final String PAYLOAD_COLLECTION_SAMPLE = "/fhir/payloads/collection-sample.json";
    public static final String PAYLOAD_OBSERVATION_SAMPLE = "/fhir/payloads/observation-sample.json";
    public static final String PAYLOAD_OBSERVATION_REAL = "/fhir/payloads/observation-real-2026.json";
    public static final String TENSIOMETRO_BUNDLES_10000 = "/fhir/tensiometro-bundles-10000.json";
    public static final String TENSIOMETRO_COLLECTION_10000 = "/fhir/tensiometro-collection-10000.json";

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
    private static final Map<String, JsonNode> CACHE = new ConcurrentHashMap<>();

    private FhirTestDataLoader() {
    }

    public static JsonNode load(String resourcePath) {
        JsonNode cached = CACHE.computeIfAbsent(resourcePath, FhirTestDataLoader::readFromClasspath);
        return cached.deepCopy();
    }

    public static JsonNode bundleSample() {
        return load(PAYLOAD_BUNDLE_SAMPLE);
    }

    public static JsonNode collectionSample() {
        return load(PAYLOAD_COLLECTION_SAMPLE);
    }

    public static JsonNode observationSample() {
        return load(PAYLOAD_OBSERVATION_SAMPLE);
    }

    public static JsonNode observationReal2026() {
        return load(PAYLOAD_OBSERVATION_REAL);
    }

    public static JsonNode collection10000() {
        return load(TENSIOMETRO_COLLECTION_10000);
    }

    public static JsonNode firstBundleFromBundles10000() {
        JsonNode bundles = load(TENSIOMETRO_BUNDLES_10000);
        if (!bundles.isArray() || bundles.isEmpty()) {
            throw new IllegalStateException("Expected non-empty bundle array in " + TENSIOMETRO_BUNDLES_10000);
        }
        return bundles.path(0).deepCopy();
    }

    public static int bundles10000Count() {
        JsonNode bundles = load(TENSIOMETRO_BUNDLES_10000);
        return bundles.isArray() ? bundles.size() : 0;
    }

    public static int collection10000ObservationCount() {
        JsonNode collection = load(TENSIOMETRO_COLLECTION_10000);
        JsonNode entries = collection.path("entry");
        if (!entries.isArray()) {
            return 0;
        }
        int count = 0;
        for (JsonNode entry : entries) {
            if ("Observation".equals(entry.path("resource").path("resourceType").asText())) {
                count++;
            }
        }
        return count;
    }

    private static JsonNode readFromClasspath(String resourcePath) {
        try (InputStream inputStream = FhirTestDataLoader.class.getResourceAsStream(resourcePath)) {
            if (inputStream == null) {
                throw new IllegalArgumentException("Resource not found: " + resourcePath);
            }
            return OBJECT_MAPPER.readTree(inputStream);
        } catch (IOException e) {
            throw new UncheckedIOException("Unable to parse JSON resource: " + resourcePath, e);
        }
    }
}
