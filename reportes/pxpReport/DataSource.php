<?php
    class DataSource {
    	
		private $parameters = array();
		private $dataset = array(); //multidimensional
		
		function __construct() {}
		
		public function setParameters($parametros) {
			$this->parametros = $parametros;
		}
		
		public function getParameters() {
			return $this->parametros;
		}
		
		public function setDataset($dataset) {
			$this->dataset = $dataset;
		}
		
		public function getDataset() {
			return $this->dataset;
		}
		
		public function putParameter($key, $value) {
			$this->parameters[$key] = $value;
		}
		
		public function getParameter($key) {
			return $this->parameters[$key];
		}
    }
?>