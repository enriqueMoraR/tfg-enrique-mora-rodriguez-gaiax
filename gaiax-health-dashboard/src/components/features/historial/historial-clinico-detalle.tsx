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

interface Props {
  historial: HistorialClinico
}

export function HistorialClinicoDetalle({ historial }: Props) {
  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle className="flex justify-between items-center">
            <span>Historial Clínico de: {historial.paciente.nombreCompleto}</span>
            <Badge variant="secondary">DNI: {historial.paciente.nifDni}</Badge>
          </CardTitle>
        </CardHeader>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Diagnósticos</CardTitle>
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

      <Card>
        <CardHeader>
          <CardTitle>Tratamientos</CardTitle>
        </CardHeader>
        <CardContent>
          {historial.tratamientos.map((t) => (
            <div key={t.idTratamiento} className="border rounded-lg p-4 mb-4">
              <h4 className="font-semibold mb-2">{t.nombreTratamiento}</h4>
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
      <Card>
        <CardHeader>
          <CardTitle>Filiación y Datos Sociodemográficos</CardTitle>
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

      <Card>
        <CardHeader>
          <CardTitle>Antecedentes del Paciente</CardTitle>
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

      <Card>
        <CardHeader>
          <CardTitle>Dispositivos IoT Médicos</CardTitle>
        </CardHeader>
        <CardContent>
          {historial.dispositivos && historial.dispositivos.length > 0 ? (
            historial.dispositivos.map((d) => (
              <div key={d.idDispositivo} className="border rounded-lg p-4 mb-4">
                <h4 className="font-semibold mb-2">{d.tipo} - {d.modelo}</h4>
                <div className="flex gap-2 mb-4">
                  <Badge variant={d.conectado ? "default" : "secondary"}>
                    {d.conectado ? 'Conectado' : 'Desconectado'}
                  </Badge>
                  <Badge variant="outline">{d.fabricante}</Badge>
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
