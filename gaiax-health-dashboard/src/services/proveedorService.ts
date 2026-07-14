import api from './api'
import { ProveedorSalud } from '@/types/proveedor'

const API_URL = '/proveedores'

/**
 * Fetches all health providers and their medical staff.
 * @returns A promise that resolves to the list of providers.
 */
export const getProveedores = async (): Promise<ProveedorSalud[]> => {
  try {
    const response = await api.get(API_URL)
    return response.data
  } catch (error) {
    console.error('Error fetching providers:', error)
    throw error
  }
}
