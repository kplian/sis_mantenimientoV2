CREATE OR REPLACE FUNCTION gem.ft_uni_cons_item_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		SISTEMA DE GESTION DE MANTENIMIENTO
 FUNCION: 		gem.ft_uni_cons_item_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'gem.tuni_cons_item'
 AUTOR: 		 (rac)
 FECHA:	        01-11-2012 11:53:15
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'gem.ft_uni_cons_item_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'GEM_UNITEM_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		rac	
 	#FECHA:		01-11-2012 11:53:15
	***********************************/

	if(p_transaccion='GEM_UNITEM_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						unitem.id_uni_cons_item,
						unitem.estado_reg,
						unitem.id_uni_cons,
						unitem.id_item,
                        item.nombre,
                        unitem.observaciones,
                        item.codigo,
						unitem.fecha_reg,
						unitem.id_usuario_reg,
						unitem.fecha_mod,
						unitem.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from gem.tuni_cons_item unitem
						inner join segu.tusuario usu1 on usu1.id_usuario = unitem.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = unitem.id_usuario_mod
                        inner join alm.titem item on item.id_item=unitem.id_item
				        where unitem.id_uni_cons = '||v_parametros.id_uni_cons||' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'GEM_UNITEM_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rac	
 	#FECHA:		01-11-2012 11:53:15
	***********************************/

	elsif(p_transaccion='GEM_UNITEM_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_uni_cons_item)
					    from gem.tuni_cons_item unitem
					    inner join segu.tusuario usu1 on usu1.id_usuario = unitem.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = unitem.id_usuario_mod
					    where ';
		
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
	else
					     
		raise exception 'Transaccion inexistente';
					         
	end if;
					
EXCEPTION
					
	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;