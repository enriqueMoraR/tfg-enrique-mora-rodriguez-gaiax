import { HistorialClinico } from '@/types/historial'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import { Badge } from '@/components/ui/badge'
import { Activity, Pill, User, FileText, Wifi } from 'lucide-react'

interface Props {
  historial: HistorialClinico
}

export function HistorialClinicoDetalle({ historial }: Props) {
  return (
    <div className="space-y-6">
      <Card className="overflow-hidden border-t-4 border-t-clinical-blue shadow-md hover:shadow-lg transition-all duration-300">
        <CardHeader className="bg-slate-50 pb-4">
          <CardTitle className="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4 text-xl">
            <div className="flex items-center gap-2 text-slate-800">
              <User className="h-5 w-5 text-clinical-blue" />
              <span>Historial Clínico: <span className="font-bold">{historial.paciente.nombreCompleto}</span></span>
            </div>
            <Badge variant="outline" className="text-sm px-3 py-1 bg-white">DNI: {historial.paciente.nifDni}</Badge>
          </CardTitle>
        </CardHeader>
      </Card>

      <Card className="shadow-sm hover:shadow-md transition-shadow duration-300">
        <CardHeader className="pb-3 border-b">
          <CardTitle className="flex items-center gap-2 text-lg text-slate-800">
            <Activity className="h-5 w-5 text-rose-500" />
            Diagnósticos
          </CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Fecha</TableHead>
                <TableHead>Descripción</TableHead>
                <TableHead>Código (CIE-10)</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {historial.diagnosticos.map((d) => (
                <TableRow key={d.idDiagnostico}>
                  <TableCell>{new Date(d.fechaDiagnostico).toLocaleDateString()}</TableCell>
                  <TableCell>{d.descripcion}</TableCell>
                  <TableCell>
                    <Badge>{d.cie10}</Badge>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <Card className="shadow-sm hover:shadow-md transition-shadow duration-300">
        <CardHeader className="pb-3 border-b">
          <CardTitle className="flex items-center gap-2 text-lg text-slate-800">
            <Pill className="h-5 w-5 text-emerald-500" />
            Tratamientos
          </CardTitle>
        </CardHeader>
        <CardContent>
          {historial.tratamientos.map((t) => (
            <div key={t.idTratamiento} className="border rounded-xl p-5 mb-6 bg-slate-50/50 hover:bg-slate-50 transition-colors">
              <h4 className="font-semibold text-slate-800 text-lg mb-2">{t.nombreTratamiento}</h4>
              <p className="text-sm text-muted-foreground mb-2">
                <strong>Indicaciones:</strong> {t.indicaciones}
              </p>
              <p className="text-sm text-muted-foreground mb-4">
                <strong>Inicio:</strong> {new Date(t.fechaInicio).toLocaleDateString()}
              </p>
              <h5 className="font-medium mb-2">Medicación Prescrita</h5>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Principio Activo</TableHead>
                    <TableHead>Dosis</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {t.medicaciones.map((m) => (
                    <TableRow key={m.idMedicacion}>
                      <TableCell>{m.principioActivo}</TableCell>
                      <TableCell>{m.dosis}</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          ))}
        </CardContent>
      </Card>
      <Card className="shadow-sm hover:shadow-md transition-shadow duration-300">
        <CardHeader className="pb-3 border-b">
          <CardTitle className="flex items-center gap-2 text-lg text-slate-800">
            <FileText className="h-5 w-5 text-blue-500" />
            Filiación y Datos Sociodemográficos
          </CardTitle>
        </CardHeader>
        <CardContent>
          {historial.filiacion && historial.filiacion.length > 0 ? (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Comunidad Autónoma</TableHead>
                  <TableHead>Centro Asignado</TableHead>
                  <TableHead>Nivel Socioeconómico</TableHead>
                  <TableHead>Idioma</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {historial.filiacion.map((f) => (
                  <TableRow key={f.idFiliacion}>
                    <TableCell>{f.comunidadAutonoma}</TableCell>
                    <TableCell>{f.centroAsignado}</TableCell>
                    <TableCell>{f.nivelSocieconomico}</TableCell>
                    <TableCell>{f.idiomaPreferido}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          ) : (
            <p className="text-sm text-muted-foreground">No hay datos de filiación registrados.</p>
          )}
        </CardContent>
      </Card>

      <Card className="shadow-sm hover:shadow-md transition-shadow duration-300">
        <CardHeader className="pb-3 border-b">
          <CardTitle className="flex items-center gap-2 text-lg text-slate-800">
            <Activity className="h-5 w-5 text-amber-500" />
            Antecedentes del Paciente
          </CardTitle>
        </CardHeader>
        <CardContent>
          {historial.antecedentes && historial.antecedentes.length > 0 ? (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Fecha Inicio</TableHead>
                  <TableHead>Tipo</TableHead>
                  <TableHead>Descripción</TableHead>
                  <TableHead>CIE-10</TableHead>
                  <TableHead>Estado</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {historial.antecedentes.map((a) => (
                  <TableRow key={a.idAntecedente}>
                    <TableCell>{new Date(a.fechaInicio).toLocaleDateString()}</TableCell>
                    <TableCell>{a.tipo}</TableCell>
                    <TableCell>{a.descripcion}</TableCell>
                    <TableCell>
                      <Badge>{a.cie10}</Badge>
                    </TableCell>
                    <TableCell>
                      {a.esActivo ? <Badge variant="destructive">Activo</Badge> : <Badge variant="secondary">Inactivo</Badge>}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          ) : (
            <p className="text-sm text-muted-foreground">No hay antecedentes registrados.</p>
          )}
        </CardContent>
      </Card>

      <Card className="shadow-sm hover:shadow-md transition-shadow duration-300">
        <CardHeader className="pb-3 border-b">
          <CardTitle className="flex items-center gap-2 text-lg text-slate-800">
            <Wifi className="h-5 w-5 text-indigo-500" />
            Dispositivos IoT Médicos
          </CardTitle>
        </CardHeader>
        <CardContent>
          {historial.dispositivos && historial.dispositivos.length > 0 ? (
            historial.dispositivos.map((d) => (
              <div key={d.idDispositivo} className="border rounded-xl p-5 mb-6 bg-slate-50/50 hover:bg-slate-50 transition-colors">
                <h4 className="font-semibold text-slate-800 text-lg mb-3">{d.tipo} - {d.modelo}</h4>
                <div className="flex gap-2 mb-5">
                  <Badge className={d.conectado ? "bg-emerald-100 text-emerald-800 hover:bg-emerald-200 border-emerald-200" : "bg-slate-100 text-slate-600 border-slate-200"}>
                    {d.conectado ? 'Conectado' : 'Desconectado'}
                  </Badge>
                  <Badge variant="outline" className="bg-white">{d.fabricante}</Badge>
                </div>
                <p className="text-sm text-muted-foreground mb-4">
                  <strong>Instalación:</strong> {new Date(d.fechaInstalacion).toLocaleDateString()}
                </p>
                <h5 className="font-medium mb-2">Últimas Lecturas</h5>
                {d.lecturas && d.lecturas.length > 0 ? (
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead>Fecha / Hora</TableHead>
                        <TableHead>Valor</TableHead>
                        <TableHead>Calidad</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {d.lecturas.map((l) => (
                        <TableRow key={l.idLectura}>
                          <TableCell>{new Date(l.timestamp).toLocaleString()}</TableCell>
                          <TableCell>{l.valor} {l.unidad}</TableCell>
                          <TableCell>{l.calidadDato}</TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                ) : (
                  <p className="text-sm text-muted-foreground">No hay lecturas recientes de este dispositivo.</p>
                )}
              </div>
            ))
          ) : (
            <p className="text-sm text-muted-foreground">El paciente no tiene dispositivos IoT vinculados.</p>
          )}
        </CardContent>
      </Card>
    </div>
  )
}
