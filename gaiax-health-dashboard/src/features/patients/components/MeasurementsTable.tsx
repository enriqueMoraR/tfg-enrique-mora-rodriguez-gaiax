import { useState, useMemo } from 'react'
import type { Measurement } from '../../../types/domain'
import { formatTimestamp, formatValue } from '../services/dataTransform'

interface MeasurementsTableProps {
  measurements: Measurement[]
  title?: string
  pageSize?: number
}

type SortKey = 'timestamp' | 'type' | 'value'
type SortOrder = 'asc' | 'desc'

export default function MeasurementsTable({
  measurements,
  title = 'Últimas Mediciones',
  pageSize = 10,
}: MeasurementsTableProps) {
  const [currentPage, setCurrentPage] = useState(1)
  const [sortKey, setSortKey] = useState<SortKey>('timestamp')
  const [sortOrder, setSortOrder] = useState<SortOrder>('desc')

  const sortedData = useMemo(() => {
    return [...measurements].sort((a, b) => {
      let aValue: any
      let bValue: any

      if (sortKey === 'timestamp') {
        aValue = new Date(a.timestamp).getTime()
        bValue = new Date(b.timestamp).getTime()
      } else if (sortKey === 'type') {
        aValue = a.type
        bValue = b.type
      } else {
        aValue = typeof a.rawValue === 'number' ? a.rawValue : a.rawValue.systolic
        bValue = typeof b.rawValue === 'number' ? b.rawValue : b.rawValue.systolic
      }

      return sortOrder === 'asc' ? aValue - bValue : bValue - aValue
    })
  }, [measurements, sortKey, sortOrder])

  const totalPages = Math.ceil(sortedData.length / pageSize)
  const startIdx = (currentPage - 1) * pageSize
  const paginatedData = sortedData.slice(startIdx, startIdx + pageSize)

  const handleSort = (key: SortKey) => {
    if (sortKey === key) {
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc')
    } else {
      setSortKey(key)
      setSortOrder('asc')
    }
    setCurrentPage(1)
  }

  if (measurements.length === 0) {
    return (
      <div className="card p-8 text-center text-gray-500">
        <p>No hay mediciones disponibles</p>
      </div>
    )
  }

  return (
    <div className="card p-6">
      <h3 className="text-lg font-semibold mb-4 text-gray-800">{title}</h3>
      <div className="overflow-x-auto">
        <table className="w-full">
          <thead>
            <tr className="border-b border-gray-300">
              <th
                className="px-4 py-2 text-left cursor-pointer hover:bg-gray-100"
                onClick={() => handleSort('timestamp')}
              >
                <div className="flex items-center gap-2">
                  Timestamp
                  {sortKey === 'timestamp' && <span className="text-xs">{sortOrder === 'asc' ? '▲' : '▼'}</span>}
                </div>
              </th>
              <th
                className="px-4 py-2 text-left cursor-pointer hover:bg-gray-100"
                onClick={() => handleSort('type')}
              >
                <div className="flex items-center gap-2">
                  Tipo
                  {sortKey === 'type' && <span className="text-xs">{sortOrder === 'asc' ? '▲' : '▼'}</span>}
                </div>
              </th>
              <th
                className="px-4 py-2 text-left cursor-pointer hover:bg-gray-100"
                onClick={() => handleSort('value')}
              >
                <div className="flex items-center gap-2">
                  Valor
                  {sortKey === 'value' && <span className="text-xs">{sortOrder === 'asc' ? '▲' : '▼'}</span>}
                </div>
              </th>
              <th className="px-4 py-2 text-left">X-Request-Id</th>
            </tr>
          </thead>
          <tbody>
            {paginatedData.map((m, idx) => (
              <tr key={idx} className="border-b border-gray-200 hover:bg-gray-50">
                <td className="px-4 py-2 text-sm text-gray-700">{formatTimestamp(m.timestamp)}</td>
                <td className="px-4 py-2 text-sm text-gray-700 font-semibold">
                  <span className="px-2 py-1 bg-gray-100 rounded text-clinical-blue">
                    {m.type === 'blood-pressure' ? 'PA' : 'FC'}
                  </span>
                </td>
                <td className="px-4 py-2 text-sm text-gray-700">
                  <div className="font-medium">{formatValue(m)}</div>
                  {(m.issued || m.performerDisplay || m.deviceDisplay || m.bodySiteDisplay) && (
                    <div className="mt-1 text-xs text-slate-500">
                      {m.issued && <span>Emitida {formatTimestamp(m.issued)}</span>}
                      {m.issued && (m.performerDisplay || m.deviceDisplay || m.bodySiteDisplay) && (
                        <span className="mx-1">·</span>
                      )}
                      {[m.performerDisplay, m.deviceDisplay, m.bodySiteDisplay].filter(Boolean).join(' · ')}
                    </div>
                  )}
                  {(m.subjectDisplay || m.encounterReference || m.consentSummary) && (
                    <div className="mt-1 text-[11px] text-slate-400">
                      {[m.subjectDisplay, m.encounterReference, m.consentSummary].filter(Boolean).join(' · ')}
                    </div>
                  )}
                </td>
                <td className="px-4 py-2 text-sm text-gray-600">
                  <span title={m.xRequestId} className="cursor-help">
                    {m.xRequestId.substring(0, 15)}...
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Pagination */}
      <div className="mt-4 flex justify-between items-center">
        <span className="text-sm text-gray-600">
          Mostrando {startIdx + 1} a {Math.min(startIdx + pageSize, sortedData.length)} de{' '}
          {sortedData.length} mediciones
        </span>
        <div className="flex gap-2">
          <button
            onClick={() => setCurrentPage(Math.max(1, currentPage - 1))}
            disabled={currentPage === 1}
            className="px-3 py-1 border border-gray-300 rounded disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-100"
          >
            ← Anterior
          </button>
          <span className="px-3 py-1 text-sm text-gray-700">
            Página {currentPage} de {totalPages}
          </span>
          <button
            onClick={() => setCurrentPage(Math.min(totalPages, currentPage + 1))}
            disabled={currentPage === totalPages}
            className="px-3 py-1 border border-gray-300 rounded disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-100"
          >
            Siguiente →
          </button>
        </div>
      </div>
    </div>
  )
}
