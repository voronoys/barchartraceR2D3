//Thanks to Joel Zief: https://bl.ocks.org/jrzief/70f1f8a5d066a286da3a1e699823470f

var tick_duration = options.tick_duration;
var top_n = options.top_n;
var height = options.height;
var width = options.width;
    
const margin = {
  top: options.margin_top,
  right: options.margin_right,
  bottom: options.margin_bottom,
  left: options.margin_left
};
  
let bar_padding = (height-(margin.bottom+margin.top))/(top_n*5);

let title = svg.append('text')
  .attr('class', 'title')
  .attr('y', 24)
  .html(options.title);
  
let subtitle = svg.append("text")
  .attr("class", "subtitle")
  .attr("y", 55)
  .html(options.subtitle);
   
let caption = svg.append('text')
  .attr('class', 'caption')
  .attr('x', width-margin.right)
  .attr('y', height-5)
  .style('text-anchor', 'end')
  .html(options.caption);

let frame = options.first_frame;
let last_frame = options.last_frame;

r2d3.onRender(function(data, svg, width, height, options) {
  
  svg.selectAll("g").remove();
  svg.selectAll("rect.bar").remove();
  svg.selectAll("text.label").remove();
  svg.selectAll("text.valueLabel").remove();
  
  data.forEach(d => {
    d.value = +d.value,
    d.last_value = +d.last_value,
    d.value = isNaN(d.value) ? 0 : d.value,
    d.frame = +d.frame,
    //d.colour = d3.hsl(d.colour);
    d.colour = d3.hsl(Math.random()*360,0.75,0.75);
  });
    
  let frameSlice = data.filter(d => d.frame == frame && !isNaN(d.value))
    .sort((a,b) => b.value - a.value)
    .slice(0, top_n);
  
  frameSlice.forEach((d,i) => d.rank = i);
  
  let x = d3.scaleLinear()
    .domain([0, d3.max(frameSlice, d => d.value)])
    .range([margin.left, width-margin.right-65]);
  
  let y = d3.scaleLinear()
    .domain([top_n, 0])
    .range([height-margin.bottom, margin.top]);
  
  let xAxis = d3.axisTop()
    .scale(x)
    .ticks(width > 500 ? 5:2)
    .tickSize(-(height-margin.top-margin.bottom))
    .tickFormat(d => d3.format(',')(d));
  
  svg.append('g')
    .attr('class', 'axis xAxis')
    .attr('transform', `translate(0, ${margin.top})`)
    .call(xAxis)
    .selectAll('.tick line')
    .classed('origin', d => d === 0);
  
   svg.selectAll('rect.bar')
     .data(frameSlice, d => d.name)
     .enter()
     .append('rect')
     .attr('class', 'bar')
     .attr('x', x(0)+1)
     .attr('width', d => x(d.value)-x(0)-1)
     .attr('y', d => y(d.rank)+5)
     .attr('height', y(1)-y(0)-bar_padding)
     .style('fill', d => d.colour);
      
   svg.selectAll('text.label')
     .data(frameSlice, d => d.name)
     .enter()
     .append('text')
     .attr('class', 'label')
     .attr('x', d => x(d.value)-8)
     .attr('y', d => y(d.rank)+5+((y(1)-y(0))/2)+1)
     .style('text-anchor', 'end')
     .html(d => d.name);
      
   svg.selectAll('text.valueLabel')
     .data(frameSlice, d => d.name)
     .enter()
     .append('text')
     .attr('class', 'valueLabel')
     .attr('x', d => x(d.value)+5)
     .attr('y', d => y(d.rank)+5+((y(1)-y(0))/2)+1)
     .text(d => d3.format(',.0f')(d.last_value));

   let frameText = svg.append('text')
     .attr('class', 'frameText')
     .attr('x', width-margin.right)
     .attr('y', height-25)
     .style('text-anchor', 'end')
     .html(~~frame)
     .call(halo, 10);
     
   let ticker = d3.interval(e => {

   frameSlice = data.filter(d => d.frame == frame && !isNaN(d.value))
     .sort((a,b) => b.value - a.value)
     .slice(0,top_n);

   frameSlice.forEach((d,i) => d.rank = i);
   x.domain([0, d3.max(frameSlice, d => d.value)]); 
     
   svg.select('.xAxis')
     .transition()
       .duration(tick_duration)
       .ease(d3.easeLinear)
       .call(xAxis);
    
   let bars = svg.selectAll('.bar').data(frameSlice, d => d.name);
    
   bars
     .enter()
     .append('rect')
     .attr('class', d => `bar ${d.name.replace(/\s/g,'_')}`)
     .attr('x', x(0)+1)
     .attr( 'width', d => x(d.value)-x(0)-1)
     .attr('y', d => y(top_n+1)+5)
     .attr('height', y(1)-y(0)-bar_padding)
     .style('fill', d => d.colour)
     .transition()
       .duration(tick_duration)
       .ease(d3.easeLinear)
       .attr('y', d => y(d.rank)+5);
          
   bars
     .transition()
       .duration(tick_duration)
       .ease(d3.easeLinear)
       .attr('width', d => x(d.value)-x(0)-1)
       .attr('y', d => y(d.rank)+5);
            
   bars
     .exit()
     .transition()
       .duration(tick_duration)
       .ease(d3.easeLinear)
       .attr('width', d => x(d.value)-x(0)-1)
       .attr('y', d => y(top_n+1)+5)
       .remove();

   let labels = svg.selectAll('.label').data(frameSlice, d => d.name);
     
   labels
     .enter()
     .append('text')
     .attr('class', 'label')
     .attr('x', d => x(d.value)-8)
     .attr('y', d => y(top_n+1)+5+((y(1)-y(0))/2))
     .style('text-anchor', 'end')
     .html(d => d.name)    
     .transition()
       .duration(tick_duration)
       .ease(d3.easeLinear)
       .attr('y', d => y(d.rank)+5+((y(1)-y(0))/2)+1);
    
   labels
     .transition()
       .duration(tick_duration)
       .ease(d3.easeLinear)
       .attr('x', d => x(d.value)-8)
       .attr('y', d => y(d.rank)+5+((y(1)-y(0))/2)+1);
     
   labels
     .exit()
     .transition()
       .duration(tick_duration)
       .ease(d3.easeLinear)
       .attr('x', d => x(d.value)-8)
       .attr('y', d => y(top_n+1)+5)
       .remove();
     
   let valueLabels = svg.selectAll('.valueLabel').data(frameSlice, d => d.name);
  
   valueLabels
     .enter()
     .append('text')
     .attr('class', 'valueLabel')
     .attr('x', d => x(d.value)+5)
     .attr('y', d => y(top_n+1)+5)
     .text(d => d3.format(',.0f')(d.last_value))
     .transition()
       .duration(tick_duration)
       .ease(d3.easeLinear)
       .attr('y', d => y(d.rank)+5+((y(1)-y(0))/2)+1);
       
   valueLabels
     .transition()
       .duration(tick_duration)
       .ease(d3.easeLinear)
       .attr('x', d => x(d.value)+5)
       .attr('y', d => y(d.rank)+5+((y(1)-y(0))/2)+1)
       .tween("text", function(d) {
               let i = d3.interpolateRound(d.last_value, d.value);
               var node = this;
               return function(t) {
                 node.textContent = d3.format(',')(i(t));
              };
            });
     
   valueLabels
     .exit()
     .transition()
       .duration(tick_duration)
       .ease(d3.easeLinear)
       .attr('x', d => x(d.value)+5)
       .attr('y', d => y(top_n+1)+5)
       .remove();
    
   frameText.html(~~frame);
     
   if(frame == last_frame) ticker.stop();
   
   frame = d3.format('.1f')((+frame) + 0.1);
   }, tick_duration);
 });
    
const halo = function(text, strokeWidth) {
  text.select(function() { return this.parentNode.insertBefore(this.cloneNode(true), this); })
    .style('fill', '#ffffff')
    .style( 'stroke','#ffffff')
    .style('stroke-width', strokeWidth)
    .style('stroke-linejoin', 'round')
    .style('opacity', 1);
};