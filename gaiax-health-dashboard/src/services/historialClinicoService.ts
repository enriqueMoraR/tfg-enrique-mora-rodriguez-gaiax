import api from './api'
import { HistorialClinico } from '@/types/historial' // Crearemos este tipo

const API_URL = '/historial'

/**
 * Fetches the complete clinical history for a given patient ID.
 * @param pacienteId The UUID of the patient.
 * @param propositoId The UUID for the purpose of access (for consent verification).
 * @param userId The UUID of the user making the request (for auditing).
 * @returns A promise that resolves to the clinical history.
 */
export const getHistorialPorPaciente = async (
  pacienteId: string,
  propositoId: string,
  userId: string
): Promise<HistorialClinico> => {
  try {
    const response = await api.get(`${API_URL}/paciente/${pacienteId}`, {
      headers: {
        'X-Proposito-ID': propositoId,
        'X-User-ID': userId,
      },
    })
    return response.data
  } catch (error) {
    console.error('Error fetching clinical history:', error)
    throw error
  }
}
