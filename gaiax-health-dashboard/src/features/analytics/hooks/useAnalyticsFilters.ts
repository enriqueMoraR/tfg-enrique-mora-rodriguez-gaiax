import { useEffect, useMemo, useState } from 'react'
import type { AnalyticsFilters } from '../types/analysis'
import {
  DEFAULT_ANALYTICS_FILTERS,
  parseAnalyticsFilters,
  sanitizeAnalyticsFilters,
  serializeAnalyticsFilters,
} from '../services/analyticsFilters'

interface UseAnalyticsFiltersOptions {
  availableMeasurementTypeKeys: string[]
}

export function useAnalyticsFilters({ availableMeasurementTypeKeys }: UseAnalyticsFiltersOptions) {
  const [filters, setFilters] = useState<AnalyticsFilters>(() => parseAnalyticsFilters(window.location.search))

  useEffect(() => {
    const nextFilters = sanitizeAnalyticsFilters(filters, availableMeasurementTypeKeys)
    const currentQuery = window.location.search.startsWith('?') ? window.location.search.slice(1) : window.location.search
    const nextQuery = serializeAnalyticsFilters(nextFilters)

    if (currentQuery !== nextQuery) {
      const nextUrl = `${window.location.pathname}${nextQuery ? `?${nextQuery}` : ''}${window.location.hash}`
      window.history.replaceState(null, '', nextUrl)
    }

    if (nextFilters.measurementType !== filters.measurementType) {
      setFilters(nextFilters)
    }
  }, [availableMeasurementTypeKeys, filters])

  useEffect(() => {
    const handlePopState = () => {
      setFilters(parseAnalyticsFilters(window.location.search))
    }

    window.addEventListener('popstate', handlePopState)
    return () => window.removeEventListener('popstate', handlePopState)
  }, [])

  const resetFilters = () => setFilters(DEFAULT_ANALYTICS_FILTERS)

  const updateFilter = <K extends keyof AnalyticsFilters>(key: K, value: AnalyticsFilters[K]) => {
    setFilters((current) => ({
      ...current,
      [key]: value,
    }))
  }

  const activeQuery = useMemo(() => serializeAnalyticsFilters(filters), [filters])

  return {
    filters,
    activeQuery,
    resetFilters,
    updateFilter,
  }
}
