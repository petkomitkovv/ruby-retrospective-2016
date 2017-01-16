def degrees_to_celsius(degrees, from_units)
  case from_units
  when 'C' then degrees
  when 'K' then degrees - 273.15
  when 'F' then (degrees - 32) / 1.8
  end
end

def degrees_from_celsius(degrees, to_units)
  case to_units
  when 'C' then degrees
  when 'K' then degrees + 273.15
  when 'F' then degrees * 1.8 + 32
  end
end

MELTING_AND_BOILING_POINTS = {
  'water' => { melting_point: 0, boiling_point: 100 },
  'ethanol' => { melting_point: -114, boiling_point: 78.37 },
  'gold' => { melting_point: 1064, boiling_point: 2700 },
  'silver' => { melting_point: 961.8, boiling_point: 2162 },
  'copper' => { melting_point: 1085, boiling_point: 2567 },
}

def convert_between_temperature_units(degrees, input_unit, output_unit)
  degrees_in_celsius = degrees_to_celsius(from_degrees, input_unit)
  degrees_from_celsius(degrees_in_celsius, output_unit)
end

def melting_point_of_substance(substance, unit) 
  degrees_from_celsius(SUBSTANCES[substance][:melting_point], unit)
end

def boiling_point_of_substance(substance, unit)
  degrees_from_celsius(MELTING_AND_BOILING_POINTS[substance][:boiling_point], unit)
end