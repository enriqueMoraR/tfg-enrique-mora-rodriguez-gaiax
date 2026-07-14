import { useEffect, useState } from 'react'
import { getProveedores } from '@/services/proveedorService'
import { ProveedorSalud } from '@/types/proveedor'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Alert, AlertDescription, AlertTitle } from '@/components/ui/alert'
import { Skeleton } from '@/components/ui/skeleton'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import { Building2, MapPin, Award, CheckCircle2, XCircle } from 'lucide-react'

function ProveedoresSkeleton() {
  return (
    <div className="space-y-6">
      <Skeleton className="h-[200px] w-full" />
      <Skeleton className="h-[200px] w-full" />
      <Skeleton className="h-[200px] w-full" />
    </div>
  )
}

export default function ProveedoresPage() {
  const [proveedores, setProveedores] = useState<ProveedorSalud[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    const fetchProveedores = async () => {
      try {
        setIsLoading(true)
        const data = await getProveedores()
        setProveedores(data)
      } catch (err) {
        setError('Error al cargar la lista de proveedores de salud.')
        console.error(err)
      } finally {
        setIsLoading(false)
      }
    }

    fetchProveedores()
  }, [])

  return (
    <section className="space-y-6 max-w-6xl mx-auto">
      <div>
        <h2 className="text-2xl font-bold tracking-tight text-slate-900">Hospitales y Proveedores de Salud</h2>
        <p className="text-slate-500 mt-2">
          Directorio de instituciones médicas y profesionales colegiados en la federación Gaia-X.
        </p>
      </div>

      {isLoading ? (
        <ProveedoresSkeleton />
      ) : error ? (
        <Alert variant="destructive">
          <AlertTitle>Error</AlertTitle>
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : proveedores.length === 0 ? (
        <Alert>
          <AlertTitle>Sin datos</AlertTitle>
          <AlertDescription>No hay proveedores de salud registrados en el sistema.</AlertDescription>
        </Alert>
      ) : (
        <div className="grid gap-6">
          {proveedores.map((proveedor) => (
            <Card key={proveedor.idProveedor} className="overflow-hidden border-t-4 border-t-blue-600">
              <CardHeader className="bg-slate-50 pb-4">
                <div className="flex justify-between items-start">
                  <div>
                    <CardTitle className="text-xl flex items-center gap-2">
                      <Building2 className="h-5 w-5 text-blue-600" />
                      {proveedor.nombreInstitucion}
                    </CardTitle>
                    <div className="mt-1 flex items-center gap-2">
                      <Badge variant="outline">{proveedor.tipoProveedor}</Badge>
                      <span className="text-xs text-slate-500">CIF: {proveedor.nifCif}</span>
                    </div>
                  </div>
                  {proveedor.idGaiaX && (
                    <Badge className="bg-green-100 text-green-800 border-green-200">
                      Gaia-X: {proveedor.idGaiaX}
                    </Badge>
                  )}
                </div>
                
                <div className="mt-4 flex flex-col sm:flex-row gap-4 text-sm text-slate-600">
                  <div className="flex items-center gap-1.5">
                    <MapPin className="h-4 w-4 text-slate-400" />
                    {proveedor.direccion}
                  </div>
                  {proveedor.certificacionSoap && (
                    <div className="flex items-center gap-1.5">
                      <Award className="h-4 w-4 text-slate-400" />
                      Certificación: <span className="font-medium text-slate-700">{proveedor.certificacionSoap}</span>
                    </div>
                  )}
                </div>
              </CardHeader>
              
              <CardContent className="pt-6">
                <h4 className="font-semibold text-slate-800 mb-4">Cuadro Médico</h4>
                
                {proveedor.medicos && proveedor.medicos.length > 0 ? (
                  <div className="border rounded-md overflow-hidden">
                    <Table>
                      <TableHeader className="bg-slate-50">
                        <TableRow>
                          <TableHead>Nombre del Profesional</TableHead>
                          <TableHead>Especialidad</TableHead>
                          <TableHead>Nº Colegiado</TableHead>
                          <TableHead>Estado</TableHead>
                        </TableRow>
                      </TableHeader>
                      <TableBody>
                        {proveedor.medicos.map((medico) => (
                          <TableRow key={medico.idMedico}>
                            <TableCell className="font-medium">{medico.nombre}</TableCell>
                            <TableCell>
                              <Badge variant="secondary" className="font-normal">
                                {medico.especialidad}
                              </Badge>
                            </TableCell>
                            <TableCell className="text-slate-500">{medico.nroColegiado}</TableCell>
                            <TableCell>
                              {medico.estadoActivo ? (
                                <div className="flex items-center gap-1.5 text-green-600 text-sm font-medium">
                                  <CheckCircle2 className="h-4 w-4" />
                                  Activo
                                </div>
                              ) : (
                                <div className="flex items-center gap-1.5 text-slate-400 text-sm font-medium">
                                  <XCircle className="h-4 w-4" />
                                  Inactivo
                                </div>
                              )}
                            </TableCell>
                          </TableRow>
                        ))}
                      </TableBody>
                    </Table>
                  </div>
                ) : (
                  <p className="text-sm text-slate-500 italic">No hay médicos registrados para este proveedor.</p>
                )}
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </section>
  )
}
