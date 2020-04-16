//////////////////////////////////////////////////////////////////////////////////////////////
////// Thanks to Joel Zief: https://bl.ocks.org/jrzief/70f1f8a5d066a286da3a1e699823470f //////
////////////////////////////////////////////////////////////////////////////////////// ///////

// Functions
const halo = function(text, strokeWidth) {
  text.select(function() { return this.parentNode.insertBefore(this.cloneNode(true), this); })
    .style('fill', '#ffffff')
    .style( 'stroke','#ffffff')
    .style('stroke-width', strokeWidth)
    .style('stroke-linejoin', 'round')
    .style('opacity', 1);
};

function update_frame_lbl(){
  var lbl = options.frame_labels.slice(frame - 1, frame);
  frame_text.html(`${lbl}`);
}

// Parameters
var tick_duration = options.tick_duration;
var top_n = options.top_n;

const margin = {
  top: options.margin_top,
  right: options.margin_right,
  bottom: options.margin_bottom,
  left: options.margin_left
};
  
let bar_padding = (height-(margin.bottom+margin.top))/(top_n*5);

let frame = options.first_frame;
let last_frame = options.last_frame;
  
// Text information
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
  
// Data split
data.forEach(d => {
  d.value = +d.value,
  d.last_value = +d.last_value,
  d.value = isNaN(d.value) ? 0 : d.value,
  d.frame = +d.frame,
  d.colour = d3.hsl(d.colour),
  d.label_fix = options.label_fix,
  d.left = margin.left;
});
  
let frame_slice = data.filter(d => d.frame == frame && !isNaN(d.value))
  .sort((a,b) => b.value - a.value)
  .slice(0, top_n);
  
frame_slice.forEach((d, i) => d.rank = i);
  
// Axis
let x = d3.scaleLinear()
  .domain([0, d3.max(frame_slice, d => d.value)])
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
  .data(frame_slice, d => d.name)
  .enter()
  .append('rect')
  .attr('class', 'bar')
  .attr('x', x(0)+1)
  .attr('width', d => x(d.value)-x(0)-1)
  .attr('y', d => y(d.rank)+5)
  .attr('height', y(1)-y(0)-bar_padding)
  .style('fill', d => d.colour);
      
svg.selectAll('text.label')
  .data(frame_slice, d => d.name)
  .enter()
  .append('text')
  .attr('class', 'label')
  .attr("x", function(d){
      if(d.label_fix){
        return d.left - 8;
        } else {
          return x(d.value) - 8;
          } 
    })
  .attr('y', d => y(d.rank)+5+((y(1)-y(0))/2)+1)
  .style('text-anchor', 'end')
  .html(d => d.name);
      
svg.selectAll('text.value_label')
  .data(frame_slice, d => d.name)
  .enter()
  .append('text')
  .attr('class', 'value_label')
  .attr('x', d => x(d.value)+5)
  .attr('y', d => y(d.rank)+5+((y(1)-y(0))/2)+1)
  .text(d => d3.format(',.0f')(d.last_value));

let frame_text = svg.append('text')
  .attr('class', 'frame_text')
  .attr('x', width-margin.right)
  .attr('y', height-25)
  .style('text-anchor', 'end')
  .call(halo, 10);
  
update_frame_lbl();

let ticker = d3.interval(e => {

  frame_slice = data.filter(d => d.frame == frame && !isNaN(d.value))
    .sort((a,b) => b.value - a.value)
    .slice(0, top_n);

  frame_slice.forEach((d,i) => d.rank = i);
  x.domain([0, d3.max(frame_slice, d => d.value)]); 
     
  svg.select('.xAxis')
    .transition()
    .duration(tick_duration)
    .ease(d3.easeLinear)
    .call(xAxis);
    
  let bars = svg.selectAll('.bar').data(frame_slice, d => d.name);
    
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
    .attr('y', d => y(d.rank)+5)
    .attr('height', y(1)-y(0)-bar_padding);
          
  bars
    .exit()
    .transition()
    .duration(tick_duration)
    .ease(d3.easeLinear)
    .attr('width', d => x(d.value)-x(0)-1)
    .attr('y', d => y(top_n+1)+5)
    .remove();

  let labels = svg.selectAll('.label').data(frame_slice, d => d.name);
     
  labels
    .enter()
    .append('text')
    .attr('class', 'label')
    .attr("x", function(d){
      if(d.label_fix){
        return d.left - 8;
        } else {
          return x(d.value)-8;
          } 
    })
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
    .attr("x", function(d){
      if(d.label_fix){
        return d.left - 8;
        } else {
          return x(d.value)-8;
          } 
    })
    .attr('y', d => y(d.rank)+5+((y(1)-y(0))/2)+1);
     
  labels
    .exit()
    .transition()
    .duration(tick_duration)
    .ease(d3.easeLinear)
    .attr("x", function(d){
      if(d.label_fix){
        return d.left - 8;
        } else {
          return x(d.value)-8;
          } 
    })
    .attr('y', d => y(top_n+1)+5)
    .remove();
     
  let value_labels = svg.selectAll('.value_label').data(frame_slice, d => d.name);
  
  value_labels
    .enter()
    .append('text')
    .attr('class', 'value_label')
    .attr('x', d => x(d.value)+5)
    .attr('y', d => y(top_n+1)+5)
    .text(d => d3.format(',.0f')(d.value))
    .transition()
    .duration(tick_duration)
    .ease(d3.easeLinear)
    .attr('y', d => y(d.rank)+5+((y(1)-y(0))/2)+1);
       
  value_labels
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
     
  value_labels
    .exit()
    .transition()
    .duration(tick_duration)
    .ease(d3.easeLinear)
    .attr('x', d => x(d.value)+5)
    .attr('y', d => y(top_n+1)+5)
    .remove();
    
  update_frame_lbl();
  
  if(frame >= last_frame) ticker.stop();
   
  frame = frame + 1;
}, tick_duration);