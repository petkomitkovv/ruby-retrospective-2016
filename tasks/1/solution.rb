TEMPERATURE_CONVERSION_CHART = {
  'C' => { 'C' => [1, 0], 'F' => [1.8, 32], 'K' => [1, 273.15] },
  'F' => { 'C' => [0.55555, -17.77], 'F' => [1, 0], 'K' => [0.55555, 255.37] },
  'K' => { 'C' => [1, -273.15], 'F' => [1.8, -459.67], 'K' => [1, 0] },
}

MELTING_AND_BOILING_POINTS_IN_CELSIUS = {
  'water' => { melting_point: 0, boiling_point: 100 },
  'ethanol' => { melting_point: -114, boiling_point: 78.37 },
  'gold' => { melting_point: 1064, boiling_point: 2700 },
  'silver' => { melting_point: 961.8, boiling_point: 2162 },
  'copper' => { melting_point: 1085, boiling_point: 2567 },
}

def convert_between_temperature_units(degrees, input_unit, output_unit)
  slope, intercept = TEMPERATURE_CONVERSION_CHART[input_unit][output_unit]
  (degrees * slope + intercept)
end

def melting_point_of_substance(substance, unit) 
  melting_pt = MELTING_AND_BOILING_POINTS_IN_CELSIUS[substance][:melting_point]
  convert_between_temperature_units(melting_pt, 'C', unit)
end

def boiling_point_of_substance(substance, unit)
  boiling_pt = MELTING_AND_BOILING_POINTS_IN_CELSIUS[substance][:boiling_point]
  convert_between_temperature_units(boiling_pt, 'C', unit)
end